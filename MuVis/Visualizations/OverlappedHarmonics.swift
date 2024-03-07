/// OverlappedHarmonics.swift
/// MuVis
///
/// The OverlappedHarmonics visualization is similar to the OverlappedOctaves visualization - except, instead of rendering just one actave in each of six rows, it renders 3 octaves in each of two rows. Both show a six-octave muSpectrum.  Immediately in front of this "fundamental" muSpectrum is the muSpectrum of the first harmonic (which is one octave above the fundamental spectrum) in a different color.  Immediately in front of this first-harmonic muSpectrum is the muSpectrum of the second harmonic (which is 19 notes higher than the fundamental muSpectrum) in a different color.  Immediately in front of this second-harmonic is the muSpectrum of the third-harmonic (which is 24 notes above the fundamental.)  And so on.
///
/// The on-screen display format has a downward-facing muSpectrum in the lower half-screen covering the lower three octaves, and an upward-facing muSpectrum in the upper half-screen covering the upper three octaves.  The following diagram shows the specific frequencies.  The letters W and B denote the white and black keys of a piano keyboard.
///
//        262 Hz                              523 Hz                             1046 Hz                         1976 Hz
//        C4                                  C5                                  C6                               B6
//         |                                   |                                   |                                |
//         W  B  W  B  W  W  B  W  B  W  B  W  W  B  W  B  W  W  B  W  B  W  B  W  W  B  W  B  W  W  B  W  B  W  B  W
//
//         W  B  W  B  W  W  B  W  B  W  B  W  W  B  W  B  W  W  B  W  B  W  B  W  W  B  W  B  W  W  B  W  B  W  B  W
//         |                                   |                                   |                                |
//         C1                                 C2                                  C3                               B3
//         33Hz                               65 Hz                              130 Hz                           247 Hz
///
/// For the fundamental muSpectrum, the spectral peaks comprising each note are a separate color, and the colors of the grid are consistent across all octaves -
/// hence all octaves of a "C" note are red; all octaves of an "E" note are green, and all octaves of a "G" note are light blue, etc.
/// We have added note names for the white notes at the top and bottom.
///
/// A novel feature of the OverlappedHarmonics visualization is the rendering of the harmonics beneath each note. We are rendering 6 harmonics of each note.
/// We will start counting from 1 - meaning that harm=1 refers to the fundamental. If the fundamental is note C1, then:
///
///	harm=1  is  C1  fundamental
///	harm=2  is  C2  octave                                               harm=3  is  G2
///	harm=4  is  C3  two octaves         harm=5  is  E3      harm=6  is  G3
/// So, harmonicCount = 6 and  harm = 1, 2, 3, 4, 5, 6.
/// The harmonic increment (harmIncrement) for our 6 rendered harmonics is 0, 12, 19, 24, 28, 31 notes.
///
/// As described above, the fundamental (harm=1) (the basic octave-aligned muSpectrum) is shown with a separate color for each note.
///
/// The first harmonic (harm=2) shows as orange; the second harmonic (harm=3) is yellow; and the third harmonic harm=4) is green, and so on.
///
/// For each audio frame, we will render a total of 6 + 6 = 12 polygons - one for each harmonic of each tri-octave.
/// totalPointCount =  96 * 12 = 1,152   // total number of points provided by the interpolator
/// sixOctPointCount = 72 * 12 =  864   // total number of points of the 72 possible fundamentals
///
//          background  foreground
// option0  keyboard    ifFundamental   noteColor
// option1  keyboard    allHarms        noteColor
// option2  keyboard    ifFundamental   vertGradient
// option3  keyboard    allHarms        vertGradient
// option4  plain       ifFundamental   noteColor
// option5  plain       allHarms        noteColor
// option6  plain       ifFundamental   vertGradient
// option7  plain       allHarms        vertGradient
//
// https://swiftui-lab.com/swiftui-animations-part5/
///
/// This copies the OverlappedHarmonics2 visualization in the Polaris project.
/// Created by Keith Bromley on 29  Dec 2021.  Modified in May 2023.


import SwiftUI


struct OverlappedHarmonics: View {
    @EnvironmentObject var manager: AudioManager    // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        let option = settings.option                // Use local short name to improve code readablity.
        
        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 36) }    // struct code in VisUtilities file
            OverlappedHarmonics_Live()
                .background( ( option < 4 ) ? Color.clear : backgroundColor )
            if( option < 4 ) {
                VerticalLines(columnCount: 36)                          // struct code in VisUtilities file
                HorizontalLines(rowCount: 2, offset: 0.0)               // struct code in VisUtilities file
                HorizontalNoteNames(rowCount: 2, octavesPerRow: 3)      // struct code in VisUtilities file
            }
        }
    }
}



struct OverlappedHarmonics_Live: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings

    var body: some View {
        
        let option = settings.option            // Use local short name to improve code readablity.
        let muSpectrum = manager.muSpectrum     // Use local short name to improve code readablity.
        
        Canvas { context, size in

            let width: Double  = size.width
            let height: Double = size.height
            let halfHeight: Double = height * 0.5
            let quarterHeight: Double = height * 0.25
            
            var x : Double = 0.0       // The drawing origin is in the upper left corner.
            var y : Double = 0.0       // The drawing origin is in the upper left corner.
            var magY: Double = 0.0     // used as a preliminary part of the "y" value
            let octavesPerRow: Int = 3
            let pointsPerRow: Int = pointsPerNote * notesPerOctave * octavesPerRow  //  12 * 12 * 3 = 432

            let now = Date()
            let time = now.timeIntervalSinceReferenceDate
            let frequency: Double = 0.05  // 1 cycle per 20 seconds
            let offset: Double = 0.5 * ( 1.0 + cos(2.0 * Double.pi * frequency * time )) // oscillates between 0 and +1
            let vertOffset: Double = offset * quarterHeight

            let harmonicCount: Int = 6  // The total number of harmonics rendered.    0 <= har <= 5     1 <= harm <= 6
            let harmHueOffset: Double = 1.0 / ( Double(harmonicCount) ) // harmHueOffset = 1/6
            let harmIncrement: [Int]  = [ 0, 12, 19, 24, 28, 31 ]   // The increment (in notes) for the six harmonics:
            //                           C1  C2  G2  C3  E3  G3
            
            var noteColor: Bool = true  // If true, spectrum is rendered with a horizontal gradient corresponding to the note color.
                                        // Otherwise, it is rendered with a vertical gradient.
            if( option==0 || option==1 || option==4 || option==5 ) { noteColor = true } else { noteColor = false }


            //----------------------------------------------------------------------------------------------------------
            // First render the fundamental (harm==1) muSpectrum on the upper and lower screen halves:
            
            for row in 0 ... 1 {                            //  row = 0, 1  refers to the lower and upper halfpane

                var path = Path()
                // Render lower 3 octaves in the bottom halfpane, and the upper 3 octaves in the upper halfplane:
                y = row==0 ? halfHeight + vertOffset : halfHeight - vertOffset
                path.move   ( to: CGPoint( x: 0.0, y: y) )   // left at vertOffset

                for point in 1 ..< pointsPerRow {
                    x = width * ( Double(point) / Double(pointsPerRow) )

                    let spectrumPoint = row==0 ? Double(muSpectrum[point]) : Double(muSpectrum[pointsPerRow + point])
                    magY = spectrumPoint * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = row==0 ? halfHeight + vertOffset + magY : halfHeight - vertOffset - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }

                y = row==0 ? halfHeight + vertOffset : halfHeight - vertOffset
                path.addLine( to: CGPoint( x: width, y: y) )        // right at vertOffset
                path.addLine( to: CGPoint( x: 0.0,   y: y) )        // left at vertOffset
                path.closeSubpath()

                if(noteColor) {
                    context.fill(path, with: .linearGradient(hue3GradientX5,
                                                             startPoint: CGPoint(x: 0.0,   y: 0.0),
                                                             endPoint: CGPoint(  x: width, y: 0.0) ) )
                } else {
                    context.fill(path, with: .linearGradient(hueGradient,
                                                             startPoint: CGPoint(x: 0.0, y: 0.0),
                                                             endPoint: CGPoint  (x: 0.0, y: height) ) )
                }

            }  // end of for(row) loop


            //----------------------------------------------------------------------------------------------------------
            // Second, render the harmonics in the upper and lower screen halves:
            
            for row in 0 ... 1 {                            // row = 0, 1  refers to the lower and upper half-panes
                for har in 1 ..< harmonicCount {            // We rendered the har=0 fundamental spectrum above.
                        
                    let hueIndex: Double = Double(har) * harmHueOffset          // hueIndex = 1/6, 2/6, 3/6, 4/6, 5/6
                    
                    let offsetFraction: Double = Double(harmonicCount-1 - har) / Double(harmonicCount-1) // 4/5, 3/5, 2/5, 1/5, 0/5
                    let harmOffset: Double = offsetFraction * vertOffset
                    
                    var path2 = Path()
                    path2.move( to: CGPoint( x: 0.0, y: row==0 ? halfHeight+harmOffset : halfHeight-harmOffset))  // left baseline
                    
                    for point in 0 ..< pointsPerRow {                   // pointsPerRow = 12 * 12 * 3 = 432
                        x = width * ( Double(point) / Double(pointsPerRow) )
                        
                        var ifFundamental: Bool = true  // If true, harmonics are rendered only if there is a non-zero fundamental.
                        if( option==0 || option==2 || option==4 || option==6 ) {ifFundamental = true} else {ifFundamental = false}
                        /*
                         Optionally, in order to decrease the visual clutter (and to be more musically meaningfull),
                         we multiply the value of the harmonics (har = 1 through 5) by the value of the fundamental (har = 0).
                         So, if there is no meaningful amplitude for the fundamental, then its harmonics are not shown
                         (or at least shown only with low amplitude).
                         */
                        let fundamentalAmp = (!ifFundamental) ? 1.0 : Double(muSpectrum[row==0 ? point : pointsPerRow+point])
                        let newPoint: Int = ( pointsPerNote * harmIncrement[har] ) + point
                        var cumulativePoints: Int = row==0 ? newPoint : pointsPerRow + newPoint
                        if(cumulativePoints >= eightOctPointCount) { cumulativePoints = eightOctPointCount-1 }
                        
                        var magY: Double = Double(muSpectrum[cumulativePoints]) * halfHeight * fundamentalAmp
                        if( cumulativePoints == eightOctPointCount-1 ) { magY = 0 }
                        y = row==0 ? halfHeight + harmOffset + magY : halfHeight - harmOffset - magY
                        path2.addLine(to: CGPoint(x: x, y: y))
                    }
                    path2.addLine(to: CGPoint(x: width, y: row==0 ? halfHeight+harmOffset : halfHeight-harmOffset)) // right baseline
                    path2.addLine(to: CGPoint(x: 0.0,   y: row==0 ? halfHeight+harmOffset : halfHeight-harmOffset)) // left  baseline
                    path2.closeSubpath()

                    context.stroke( path2,
                                    with: .color(Color( hue: hueIndex, saturation: 1.0, brightness: 1.0 ) ),
                                    lineWidth: 1 )

                    context.fill( path2,
                                  with: .color(Color( hue: hueIndex, saturation: 1.0, brightness: 1.0 ) ) )

                } // end of for(har) loop
            } // end of for(row) loop

        }  // end of Canvas
    }  // end of var body: some View
}  // end of OverlappedHarmonics_Live struct
