/// PianoKeyboard.swift
/// MuVis
///
/// The PianoKeyboard visualization is similar to the MusicSpectrum visualization in that it shows an amplitude vs. exponential-frequency spectrum of the audio waveform.
/// The horizontal axis covers 6 octaves from leftFreqC1 = 32 Hz to rightFreqB8 = 2033 Hz -  that is from bin = 12 to bin = 755.  For a pleasing effect, the vertical axis
/// shows both an upward-extending spectrum in the upper-half screen and a downward-extending spectrum in the lower-half screen.
///
/// We have added a piano-keyboard overlay to clearly differentiate the black notes (in gray) from the white notes (in white).
/// Also, we have added note names for the white notes at the top and bottom.
///
/// The spectral peaks comprising each note are a separate color. The colors of the grid are consistent across all octaves - hence all octaves of a "C" note are red;
/// all octaves of an "E" note are green, and all octaves of a "G" note are light blue, etc. Many of the subsequent visualizations use this same note coloring scheme.
/// I have subjectively selected these to provide high color difference between adjacent notes.
///
//          background  foreground
// option0  keyboard    horGradient verLines    NoteNames
// option1  keyboard    horGradient verLines    NoteNames   peaks
// option2  keyboard    verGradient verLines    NoteNames   peaks
// option3  keyboard    verGradient verLines    NoteNames   notes
// option4  plain       horGradient                         notes
// option5  plain       horGradient                         peaks
// option6  plain       verGradient                         peaks
// option7  plain       verGradient

/// Created by Keith Bromley in May 2023.

import SwiftUI


struct PianoKeyboard: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings

    var body: some View {
        let option = settings.option                // Use local short name to improve code readablity.

        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 72) } // struct code in VisUtilities file
            PianoKeyboard_Live()
            if( option < 4 ) { VerticalLines(columnCount: 72) }
            if( option < 4 ) { HorizontalNoteNames(rowCount: 2, octavesPerRow: 6) }
            if( option==1 || option==2 || option==5 || option==6 ) { Peaks72() }
            if( option==3 || option==4 ) { Notes(noteCount: 72) }
        }
    }
}

#Preview("PianoKeyboard") {
    PianoKeyboard()
        .enhancedPreview()
}

// MARK: - PianoKeyboard_Live

struct PianoKeyboard_Live: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    
    let noteProc = NoteProcessing()
    
    var body: some View {

        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        GeometryReader { geometry in

            let width  : CGFloat = geometry.size.width
            let height : CGFloat = geometry.size.height
            let halfHeight : CGFloat = height * 0.5
            
            var x : CGFloat = 0.0       // The drawing origin is in the upper left corner.
            var y : CGFloat = 0.0       // The drawing origin is in the upper left corner.
            var magY: CGFloat = 0.0     // used as a preliminary part of the "y" value
            var upRamp : CGFloat = 0.0
            let octavesPerRow : Int = 6
            let pointsPerRow : Int = pointsPerNote * notesPerOctave * octavesPerRow  //  12 * 12 * 6 = 864
            
            // Use local short name to improve code readablity:
            let spectrum = manager.spectrum
            let muSpectrum = manager.muSpectrum
            let option = settings.option

            // Use the muSpectrum points from 189 to 755 - that is the 4 octaves from 32 Hz to 508 Hz.
            let lowerPoint: Int = 1             // render the muSpectrum points from 1 to 4*144 = 576
            let upperPoint: Int = 4 * 144       // render the muSpectrum points from 1 to 4*144 = 576
            
            // Use the spectrum bins from 189 to 755 - that is the 2 octaves from 508 Hz to 2,033 Hz.
            let lowerBin: Int = noteProc.octBottomBin[4]    // render the spectrum bins from 189 to 755
            let upperBin: Int = noteProc.octTopBin[5]       // render the spectrum bins from 189 to 755

            
            // Render the lower 4 octaves of the muSpectrum along the upper left-half of the horizontal axis:
            Path { path in
                path.move( to: CGPoint( x: 0.0,   y: halfHeight))       // left midpoint
                
                for point in lowerPoint ..< upperPoint {
                    upRamp =  CGFloat(point) / CGFloat(pointsPerRow)
                    x = upRamp * width
                    magY = CGFloat(muSpectrum[point]) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                // Render the upper 2 octaves of the spectrum along the upper right-half of the horizontal axis:
                for bin in lowerBin ... upperBin {
                    x = width * noteProc.binXFactor6[bin]
                    magY = CGFloat(spectrum[bin]) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine( to: CGPoint( x: width, y: halfHeight ) )  // right midpoint
                
                // TODO: Reduntant code below; Room for optimization!
                // Mirror the upper half of the screen on the bottom half.
                
                // Render the upper 2 octaves of the spectrum along the lower right-half of the horizontal axis:
                for bin in (lowerBin ... upperBin).reversed() {
                    x = width * noteProc.binXFactor6[bin]
                    magY = CGFloat(spectrum[bin]) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight + magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                // Render the lower 4 octaves of the muSpectrum along the upper left-half of the horizontal axis:
                for point in (lowerPoint ..< upperPoint).reversed()  {
                    upRamp =  CGFloat(point) / CGFloat(pointsPerRow)
                    x = upRamp * width
                    magY = CGFloat( muSpectrum[point] ) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight + magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine( to: CGPoint( x: 0.0,   y: halfHeight))    // left midpoint
                path.closeSubpath()

            }  // end of Path
            .background( ( option > 3 ) ? backgroundColor : Color.clear )
            .foregroundStyle( ( option==0 || option==1 || option==4 || option==5 ) ?
                .linearGradient(hue6GradientX5, startPoint: .leading, endPoint: .trailing) :    // horGradient
                .linearGradient(hueGradient,  startPoint: .top,     endPoint: .bottom))         // verGradient
            
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of PianoKeyboard_Live struct

#Preview("PianoKeyboard_Live") {
    PianoKeyboard_Live()
        .enhancedPreview()
}

// MARK: - Notes

// This View shows the best computed estimate of actual notes as gray heavy vertical lines:
// The currentNote array will contain 8 noteNums (0-71).  If the element is 99, it is not a playing currentNote.
struct Notes: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    
    @Environment(\.colorScheme) var colorScheme
    var noteCount: Int
    
    var body: some View {
        Canvas(rendersAsynchronously: true) { context, size in
            let width: Double  = size.width
            let height: Double = size.height
            let columnWidth: Double = width / Double(noteCount)
            let currentNotes: [Int] = manager.currentNotes
            
            // Paint the note with it's noteColor if it has sufficient noteScore (up to 8 current notes)
            for i in 0 ..< 8 {
                if(currentNotes[i] == 99) {break}
                let tempX: Double = Double(currentNotes[i]) * columnWidth
                context.fill(
                    Path(CGRect(x: tempX, y: 0.0, width: columnWidth, height: height)),
                    with: .color( (colorScheme == .light) ? .black.opacity(0.6) : .white.opacity(0.6)) )
            }
        }
    }
}

#Preview("Notes") {
    Notes(noteCount: 72)
        .enhancedPreview()
}

// MARK: - Peaks72

// This View shows the 16 loudest spectral peaks as "blips" at the pane top and bottom:
fileprivate struct Peaks72: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    
    @Environment(\.colorScheme) var colorScheme
    
    var noteProc = NoteProcessing()
    
    var body: some View {
        Canvas { context, size in
            var x: CGFloat = 0.0

            for peakNum in 0 ..< peakCount {                                            // peakCount = 16

                x = size.width * noteProc.binXFactor6[manager.peakBinNumbers[peakNum]]

                context.fill(
                    Path(CGRect(x: x, y: 0.0, width: 2.0, height: 0.05 * size.height)),
                    with: .color((colorScheme == .light) ? .black : .white) )

                context.fill(
                    Path(CGRect(x: x, y: 0.95 * size.height, width: 2.0, height: 0.05 * size.height)),
                    with: .color((colorScheme == .light) ? .black : .white) )
            }
        }
    }
}

#Preview("Peaks72") {
    Peaks72()
        .enhancedPreview()
}
