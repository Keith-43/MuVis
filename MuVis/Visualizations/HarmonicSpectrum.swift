/// HarmonicSpectrum.swift
/// MuVis
///
/// The HarmonicSpectrum visualization is similar to the OverlappedOctaves visualization - except, instead of rendering just one actave in each of six rows, it renders 3 octaves in each of two rows. Both show a six-octave muSpectrum.  Immediately in front of this "fundamental" muSpectrum is the muSpectrum of the first harmonic (which is one octave above the fundamental spectrum) in a different color.  Immediately in front of this first-harmonic muSpectrum is the muSpectrum of the second harmonic (which is 19 notes higher than the fundamental muSpectrum) in a different color.  Immediately in front of this second-harmonic is the muSpectrum of the third-harmonic (which is 24 notes above the fundamental.)  And so on.
///
///
/// Harmonic Product Spectrum
/// http://noll.uscannenberg.org/ScannedPapers/Harmonic%20Sum%20Paper.zip   <- original 1969 paper
/// http://musicweb.ucsd.edu/~trsmyth/analysis/Harmonic_Product_Spectrum.html
/// https://gist.github.com/carlthome/1e7244e31bd628a0dba233b6dceebaef
/// https://dsp.stackexchange.com/questions/65925/harmonic-product-spectrum-from-fft-output-to-the-fundamental-frequency
/// https://stackoverflow.com/questions/60947181/how-to-denormalize-values-to-do-the-harmonic-product-spectrum
/// https://surveillance9.sciencesconf.org/data/151173.pdf
/// https://doi.org/10.1121/1.1910902
/// https://www.ijeei.org/docs-16393020145c6a448352e92.pdf
///
///
/// For the fundamental muSpectrum, the spectral peaks comprising each note are a separate color, and the colors of the grid are consistent across all octaves -
/// hence all octaves of a "C" note are red; all octaves of an "E" note are green, and all octaves of a "G" note are light blue, etc.
/// We have added note names for the white notes at the top and bottom.
///
/// A novel feature of the HarmonicSpecttru visualization is the rendering of the harmonics beneath each note. We are rendering 6 harmonics of each note.
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
/// For each audio frame, we will render a total of 6  polygons - one for each harmonic of the spectrum
/// totalPointCount   =  96 x 12 = 1,152   // total number of points provided by the interpolator
/// sixOctPointCount = 72 x 12 =    864   // total number of points of the 72 possible fundamentals
///
//          background              foreground
// option0  keyboard                harmHue
// option1  keyboard                hue = 0
// option2  keyboard                hue = 0.33
// option3  keyboard                hue = 0.66
// option4  plain (white/black)     harmHue
// option5  plain (pink/blue)       hue = 0
// option6  plain                   hue = 0.33
// option7  plain                   hue = 0.66
///
/// Created by Keith Bromley in June 2023.


import SwiftUI


struct HarmonicSpectrum: View {
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let option = settings.option                // Use local short name to improve code readablity.
        
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white

        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 72) }        // struct code in VisUtilities file
            HarmonicSpectrum_Live()
                .background( ( option < 4 ) ? Color.clear : backgroundColor )
            if( option < 4 ) {
                VerticalLines(columnCount: 72)                              // struct code in VisUtilities file
                HorizontalLines(rowCount: 8, offset: 0.0)                   // struct code in VisUtilities file
                HorizontalNoteNames(rowCount: 2, octavesPerRow: 6)          // struct code in VisUtilities file
            }
        }
    }
}

#Preview("HarmonicSpectrum") {
    HarmonicSpectrum()
        .enhancedPreview()
}

// MARK: - HarmonicSpectrum_Live

private struct HarmonicSpectrum_Live: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    
    var body: some View {

        let option = settings.option            // Use local short name to improve code readablity.
        let muSpectrum = manager.muSpectrum     // Use local short name to improve code readablity.
        
        // var harmHue: Double = (option==2 || option==6) ? 0.0 : 0.5

        GeometryReader { geometry in

            let width: Double  = geometry.size.width
            let height: Double = geometry.size.height
            let threeQuartersHeight: Double = height * 0.75
            let rowHeight: Double = height * 0.125       // 1/8 = 0.125

            var x : Double = 0.0       // The drawing origin is in the upper left corner.
            var y : Double = 0.0       // The drawing origin is in the upper left corner.
            var upRamp : Double = 0.0
            var magY: Double = 0.0     // used as a preliminary part of the "y" value
            let octavesPerRow: Int = 6
            let pointsPerRow: Int = pointsPerNote * notesPerOctave * octavesPerRow  //  12 * 12 * 6 = 864

            let harmonicCount: Int = 6  // The total number of harmonics rendered.    0 <= har <= 5     1 <= harm <= 6
            let harmHueOffset: Double = 1.0 / ( Double(harmonicCount) ) // harmHueOffset = 1/6
            let harmIncrement: [Int]  = [ 0, 12, 19, 24, 28, 31 ]   // The increment (in notes) for the six harmonics:
            //                           C1  C2  G2  C3  E3  G3

            //----------------------------------------------------------------------------------------------------------
            // Render the harmonics (the muSpectra for har == 0...6) at halfHeight + har*rowHeight:

            ForEach( 0 ..< harmonicCount, id: \.self) { har in                  // har = 0, 1, 2, 3, 4, 5

                Text("harmonic \( har )")
                    .position(x: 0.05 * width , y: threeQuartersHeight - (Double(har) + 0.9) * rowHeight)

                var harmHue: Double = Double(har) * harmHueOffset               // harmHue = 1/6, 2/6, 3/6, 4/6, 5/6
                
                let harmFraction: Double = Double(har) / Double(harmonicCount)  // 1/6, 2/6, 3/6, 4/6, 5/6
                let harmOffset: Double = harmFraction * threeQuartersHeight

                Path { path in
                    path.move( to: CGPoint( x: 0.0, y: threeQuartersHeight - harmOffset))  // left baseline

                    for point in 0 ..< pointsPerRow {                   // pointsPerRow = 12 * 12 * 6 = 864
                        upRamp =  Double(point) / Double(pointsPerRow)
                        x = upRamp * width
                        let newPoint: Int = ( pointsPerNote * harmIncrement[har] ) + point
                        var cumulativePoints: Int = newPoint
                        if(cumulativePoints >= eightOctPointCount) { cumulativePoints = eightOctPointCount-1 }
                        magY = Double( muSpectrum[ cumulativePoints ] ) * rowHeight
                        if( cumulativePoints == eightOctPointCount-1 ) { magY = 0 }
                        magY = min(max(0.0, magY), rowHeight)
                        y = threeQuartersHeight - harmOffset - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    path.addLine( to: CGPoint( x: width, y: threeQuartersHeight - harmOffset ) ) // right baseline
                    path.addLine( to: CGPoint( x: 0.0,   y: threeQuartersHeight - harmOffset ) ) // left baseline
                    path.closeSubpath()
                }
                .fill( Color( hue:  (option==1 || option==5) ? 0.0 :
                                    (option==2 || option==6) ? 0.33 :
                                    (option==3 || option==7) ? 0.66 : harmHue,
                              saturation: 1.0,
                              brightness: 1.0 ) ,
                       strokeColor: Color( (colorScheme == .dark) ? .black : .white ),
                       lineWidth: 1 )                                           // See the extension to Shape() below.

            } // end of ForEach(har)


            // Render the HarmonicSumSpectrum at height - rowHeight:
            Text("Harmonic Sum Spectrum")
                .position(x: 0.1 * width , y: height - 1.9 * rowHeight)
            
            let harmSumSpectrum = noteProc.computeHarmSumSpectrum(inputArray: muSpectrum)

            Path { path4 in
                path4.move( to: CGPoint( x: 0.0, y: height - rowHeight))  // left baseline

                for point in 0 ..< pointsPerRow {                   // pointsPerRow = 12 * 12 * 6 = 864
                    upRamp =  Double(point) / Double(pointsPerRow)
                    x = upRamp * width
                    magY = Double( harmSumSpectrum[point] ) * 0.166666 * rowHeight       // 1/6 = 0.166666
                    magY = min(max(0.0, magY), rowHeight)
                    y = height - rowHeight - magY
                    path4.addLine(to: CGPoint(x: x, y: y))
                }
                path4.addLine( to: CGPoint( x: width, y: height - rowHeight ) ) // right baseline
                path4.addLine( to: CGPoint( x: 0.0,   y: height - rowHeight ) ) // left baseline
                path4.closeSubpath()
            }
            .fill( Color( (colorScheme == .dark) ? .white : .black  ),
                   strokeColor: Color( (colorScheme == .dark) ? .black : .white ),
                   lineWidth: 1 )                                               // See the extension to Shape() below.
            
            
            
            // Render the HarmonicProductSpectrum at height:
            Text("Harmonic Product Spectrum")
                .position(x: 0.1 * width , y: height - 0.9 * rowHeight)
            
            let harmProdSpectrum = noteProc.computeHarmProdSpectrum(inputArray: muSpectrum)
            
            Path { path3 in
                path3.move( to: CGPoint( x: 0.0, y: height))  // left baseline

                for point in 0 ..< pointsPerRow {                   // pointsPerRow = 12 * 12 * 6 = 864
                    upRamp =  Double(point) / Double(pointsPerRow)
                    x = upRamp * width

                    magY = Double( harmProdSpectrum[point] ) * 1_000.0 * rowHeight
                    magY = min(max(0.0, magY), rowHeight)
                    y = height - magY
                    path3.addLine(to: CGPoint(x: x, y: y))
                }
                path3.addLine( to: CGPoint( x: width, y: height ) ) // right baseline
                path3.addLine( to: CGPoint( x: 0.0,   y: height ) ) // left baseline
                path3.closeSubpath()
            }
            .fill( Color( (colorScheme == .dark) ? .white : .black  ),
                   strokeColor: Color( (colorScheme == .dark) ? .black : .white ),
                   lineWidth: 1 )                                               // See the extension to Shape() below.

        }  // end of GeometryReader

    }  // end of var body: some View
}  // end of HarmonicSpectrum_Live struct

#Preview("HarmonicSpectrum") {
    HarmonicSpectrum()
        .enhancedPreview()
}
