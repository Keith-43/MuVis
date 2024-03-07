/// OctaveAlignedSpectrum.swift
/// MuVis
///
/// The OctaveAlignedSpectrum (OAS) visualization is one of the bedrock visualizations of this app. It is similar to the LinearOAS visualization except that the
/// octaves are laid out one above the other. This is ideal for examining the harmonic structure.
///
/// The graphical structure depicted is a grid of 8 rows by 12 columns. Each of the 8 rows contains all 12 notes within that one octave.
/// Each of the 12 columns contains 8 octaves of that particular note.
///
/// Each octave is a standard spectrum display (converted from linear to exponential frequency) covering one octave. Each octave is overlaid one octave above the
/// next-lower octave. (Note that this requires compressing the frequency range by a factor of two for each octave.)
///
/// We typically use the Spectrum array to render it.  The top row shows half of the spectral bins (but over an exponential axis).
/// The next-to-the-top row would show half of the remaining bins (but stretched by a factor of 2 to occupy the same length as the top row).
/// The next-lower-row would show half of the remaining bins (but stretched by a factor of 4 to occupy the same length as the top row).  And so on.
/// Observe that the bottom row might contain only a small number of bins (perhaps 12) whereas the top row might contain a very large number of bins
/// (perhaps 12 times two-raised-to-the-sixth-power). The resultant increased resolution at the higher octaves might prove very useful in determining when
/// a vocalist is on- or off-pitch.
///
///  How to create a Conditional View Modifier in SwiftUI
///  https://www.avanderlee.com/swiftui/conditional-view-modifier/
///  https://www.hackingwithswift.com/books/ios-swiftui/conditional-modifiers
///  https://designcode.io/swiftui-handbook-conditional-modifier
///
//          background                                      foreground
// option0  keyboard    horLines    verLines    NoteNames   pomegranate
// option1  keyboard    horLines    verLines    NoteNames   horGradient
// option2  keyboard    horLines    verLines                teal
// option3  keyboard    horLines    verLines                orange
// option4  plain                                           pomegranate
// option5  plain                                           horGradient
// option6  plain                                           teal
// option7  plain                                           orange
//
/// In this visualization's code, we use the names row and oct interchangeably.

/// Created by Keith Bromley in May 2023.

import SwiftUI


struct OctaveAlignedSpectrum: View {
    @EnvironmentObject var manager: AudioManager  // Observe instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    var body: some View {
        let option = settings.option     // Use local short name to improve code readablity.
        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 12) }                // struct code in VisUtilities file
            if( option < 2 ) { HorizontalNoteNames(rowCount: 2, octavesPerRow: 1) } // struct code in VisUtilities file
            OctaveAlignedSpectrum_Live()
            if( option < 4 ) { HorizontalLines(rowCount: 8, offset: 0.0) }          // struct code in VisUtilities file
            if( option < 4 ) { VerticalLines(columnCount: 12) }                     // struct code in VisUtilities file
        }
    }
}



struct OctaveAlignedSpectrum_Live: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView.
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    let pomegranate = Color(red: 192.0/255.0, green: 57.0/255.0, blue: 43.0/255.0)	// pomegranate red
    let teal = Color(red: 0.0/255.0, green: 142.0/255.0, blue: 151.0/255.0)			// Miami Dolphins teal
    let orange = Color(red: 243.0/255.0, green: 108.0/255.0, blue: 33.0/255.0)      // Netherlands orange
    let blue = Color(red: 0.0/255.0, green: 51.0/255.0, blue: 141.0/255.0)      	// Buffalo Bills blue
    let pink = Color(red: 255.0/255.0, green: 192.0/255.0, blue: 203.0/255.0)       // light pink
    
    var body: some View {
        
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        GeometryReader { geometry in
            /*
            This is a two-dimensional grid containing 8 rows and 12 columns.
            Each of the 8 rows contains 1 octave or 12 notes.
            Each of the 12 columns contains 8 octaves of that particular note.
            The entire grid renders 8 octaves or 96 notes or 756 bins.
            */

            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            var x : CGFloat = 0.0       // The drawing origin is in the upper left corner.
            var y : CGFloat = 0.0       // The drawing origin is in the upper left corner.
            let octaveCount : Int = 8  // The FFT provides 8 octaves.
            let rowHeight : CGFloat = height / CGFloat(octaveCount)
            var upRamp : CGFloat = 0.0
            var magY:  CGFloat = 0.0        // used as a preliminary part of the "y" value

            // Use local short name to improve code readablity:
            let spectrum = manager.spectrum
            let muSpectrum = manager.muSpectrum
            let option = settings.option
            
            Path { path in
                
                // Render the lower 4 octaves of the muSpectrum in our cartesian grid:
                for row in 0 ..< 4 {      //  Rows 0, 1, 2, 3 render octaves 0, 1, 2, 3.
                    let rowCG: CGFloat = CGFloat(row)      // the integer "row" cast as a CGFloat
                    
                    path.move( to: CGPoint( x: 0.0, y: height - (rowCG * rowHeight) ) )
                    
                    // Extend the path from left to right across the pane
                    for point in 0 ..< pointsPerOctave {
                        // upRamp goes from 0.0 to 1.0 as point goes from 0 to pointsPerOctave
                        upRamp =  CGFloat(point) / CGFloat(pointsPerOctave)
                        x = upRamp * width
                        
                        magY = CGFloat(muSpectrum[row * pointsPerOctave + point]) * rowHeight
                        magY = min(max(0.0, magY), rowHeight)
                        y = height - rowCG * rowHeight - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                    magY = CGFloat(muSpectrum[(row+1) * pointsPerOctave]) * rowHeight
                    y = height - rowCG * rowHeight - magY
                    path.addLine(to: CGPoint(x: width, y: y ))                              // right-hand pane border
                    path.addLine(to: CGPoint(x: width, y: height - rowCG * rowHeight ))     // right-hand pane border
                    path.addLine(to: CGPoint(x: 0.0,   y: height - rowCG * rowHeight ))     // left-hand pane border
                }
                
                // Render the upper 4 octaves of the spectrum in our cartesian grid:
                for row in 4 ..< octaveCount {      //  Rows 4, 5, 6, 7 render octaves 4, 5, 6, 7.
                    let rowCG: CGFloat = CGFloat(row)      // the integer "row" cast as a CGFloat
                    path.move(to: CGPoint( x: 0.0, y: height - rowCG * rowHeight ) )  // left-hand pane border
                    
                    for bin in noteProc.octBottomBin[row] ... noteProc.octTopBin[row] {
                        x = noteProc.binXFactor[bin] * width
                        magY = CGFloat( spectrum[bin] ) * rowHeight
                        magY = min(max(0.0, magY), rowHeight)
                        y = height - rowCG * rowHeight - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }

                    path.addLine(to: CGPoint(x: width, y: height - rowCG * rowHeight ))  // right-hand pane border
                    path.addLine(to: CGPoint(x: 0.0, y: height - rowCG * rowHeight ))    // left-hand pane border
                    path.closeSubpath()
                }

            }  // end of Path
            .background( ( option > 3 ) ? backgroundColor : Color.clear )
            .foregroundStyle(
                ( option==0 || option==4 ) ?
                    .linearGradient(colors: [pomegranate, pomegranate], startPoint: .leading, endPoint: .trailing) :

                ( option==2 || option==6 ) ?
                    .linearGradient(colors: [teal, teal], startPoint: .leading, endPoint: .trailing) :

                ( option==3 || option==7 ) ?
                    .linearGradient(colors: [orange, orange], startPoint: .leading, endPoint: .trailing) :
                    .linearGradient(hueGradientX5, startPoint: .leading, endPoint: .trailing) )

        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of OctaveAlignedSpectrum_Live struct
