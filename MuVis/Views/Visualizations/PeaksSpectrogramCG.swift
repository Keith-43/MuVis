///  Peaks Spectrogram.swift
///  MuVis
///
///  CGImage, UIImage, NSImage:
///  https://medium.com/@ranleung/uiimage-vs-ciimage-vs-cgimage-3db9d8b83d94
///  A CGImage can only represent bitmaps.
///  CGImage, which comes from Core Graphics. This is a simpler image type that is really just a two-dimensional array of pixels.
///  https://www.hackingwithswift.com/books/ios-swiftui/integrating-core-image-with-swiftui
///  https://developer.apple.com/documentation/coregraphics/cgimage
///  https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007533-SW1
///
///  This is a spectrogram of the 16 peaks using CGContext from Core Graphics.
///
//           foreground     color       background
//  option0  stationary     usePeakAmp  keyboard
//  option1  stationary     usePeakAmp  plain
//  option2  stationary     position    keyboard
//  option3  stationary     position    plain
//  option4  scroll         usePeakAmp  keyboard
//  option5  scroll         usePeakAmp  plain
//  option6  scroll         position    keyboard
//  option7  scroll         position    plain
///
/// Created by Keith Bromley on 15 Sep 2023.

import SwiftUI



struct PeaksSpectrogramCG: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.displayScale) var displayScale: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    private var pane = Pane()

    var body: some View {
        ZStack {
            Image(decorative: pane.drawLine( binNumData: manager.peakBinNumbers,
                                             peakAmpData: manager.peakAmps,
                                             scheme: colorScheme,
                                             option: settings.option),
                  scale: displayScale,
                  orientation: .up
            )
            .resizable()

            VerticalNoteNames(columnCount: 2, octavesPerColumn: 6)              // struct code in VisUtilities file
        }
    }
}

#Preview("PeaksSpectrogramCG") {
    PeaksSpectrogramCG()
        .enhancedPreview()
}

// MARK: - Pane

private struct Pane {
    let noteProc = NoteProcessing()
    static let myHistCount: Int = 1_000                         // 1,000 horizontal pixels
    let octaveCount: Int = 6                                    // This visualization will cover 6 octaves.
    static var counter: Int = 0
    static var cgImage: CGImage?

    let context = CGContext(data: nil,
                            width: myHistCount,                 // context.width  = 1_000
                            height: sixOctPointCount,           // context.height =   864
                            bitsPerComponent: 8,
                            bytesPerRow: myHistCount * 4,
                            space: CGColorSpace(name: CGColorSpace.sRGB)!,
                            // bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue )
                            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue )

    let width  = Double( myHistCount )                          // width  = 1_000.0
    let height = Double( sixOctPointCount )                     // height =   864.0
    let columnWidth: Double = 1.0
    let rowHeight: Double = 1.0

    @MainActor func drawLine( binNumData: [Int], peakAmpData: [Double], scheme: ColorScheme, option: Int ) -> CGImage {

        // Fill drawing pane with white or black at start of every spectrogram screen:
        if( Pane.counter == 0 ) {
            let fillColor: CGColor = (scheme == .light) ? .white : .black
            context?.setFillColor(fillColor)
            context?.fill( CGRect( x: 0.0, y: 0.0, width: width, height: height ) )
        }
        
        var showKeyboard: Bool = true   // If true, a keyboard is rendered (otherwise white or black background).
        var usePeakAmp: Bool = true     // If true, the color is based upon the amplitude of that peak (otherwise the peakNum).
        var scroll: Bool = false        // If true, the spectrogram scrolls across the screen (otherwise stationary).
        
        if(option==4 || option==5 || option==6 || option==7) {scroll = true}       else {scroll = false}
        if(option==0 || option==1 || option==4 || option==5) {usePeakAmp = true}   else {usePeakAmp = false}
        if(option==0 || option==2 || option==4 || option==6) {showKeyboard = true} else {showKeyboard = false}

        var fractionX: Double = 0.0

        if( scroll == true ) { fractionX = 1.0 }
        else { fractionX = Double(Pane.counter) / Double(Pane.myHistCount) }      // 0.0 <= fractionX <= 1.0

        if( scroll == true ) {
            let translatedRect = CGRect( x: -1.0, y: 0.0, width: width, height: height )

            // Render the recursively-translated previous spectral lines into the context:
            if Pane.cgImage != nil {  // The first pass through this recursive loop will have cgImage = nil.
                context?.draw(Pane.cgImage!, in: translatedRect) // context is translated to fit into the rectangle
            }
        }

        //--------------------------------------------------------------------------------------------------------------
        // First render the line for the background (optionally containing the keyboard):
        context?.beginPath()
        for octave in 0 ..< octaveCount {                                                   // 0 <= octave < 6
            for note in 0 ..< notesPerOctave {                                              // 0 <= note < 12
                
                let note1 = octave * notesPerOctave + note                                  // 0 <= note1 < 72
                let fractionY  = Double( note1     ) / Double( sixOctNoteCount )
                let fractionY1 = Double( note1 + 1 ) / Double( sixOctNoteCount )
                context?.move(   to: CGPoint( x: width * fractionX, y: height * fractionY  ) )
                context?.addLine(to: CGPoint( x: width * fractionX, y: height * fractionY1 ) )
                
                if( showKeyboard == true ) {
                    if (accidentalNotes[note] == true) {                         // accidental notes
                        let strokeColor1: CGColor = ( scheme == .dark ?
                                                      CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) :    // black
                                                      CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) )    // light gray
                        context?.setStrokeColor( strokeColor1 )
                        context?.strokePath()
                    } else {                                                    // natural notes
                        let strokeColor2: CGColor = ( scheme == .dark ?
                                                      CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) :    // dark gray
                                                      CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )    // white
                        context?.setStrokeColor( strokeColor2 )
                        context?.strokePath()
                    }

                } else {
                    let strokeColor3: CGColor = ( scheme == .dark ?
                                                  CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) :    // black
                                                  CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )    // white
                    context?.setStrokeColor( strokeColor3 )
                    context?.strokePath()
                }
            }
        }

        //--------------------------------------------------------------------------------------------------------------
        // now render the line segment containing the peaks:
        context?.beginPath()

        for peakNum in 0 ..< peakCount{         // 0 <= peakNum < 16

            if( binNumData[peakNum] != 0 ) {      // Only render a line segment for non-zero bin numbers.

                // As bin goes from 12 to 755, binXFactor6 goes from 0.0 to 1.0
                let fractionY = noteProc.binXFactor6[ binNumData[peakNum] ]

                let amplitude = usePeakAmp==true ? peakAmpData[peakNum] : Double(peakCount-1 - peakNum) / Double(peakCount)
                let halfAmp = 0.8 * amplitude

                context?.move(   to: CGPoint( x: width * fractionX, y: height * fractionY - halfAmp ) )
                context?.addLine(to: CGPoint( x: width * fractionX, y: height * fractionY + halfAmp ) )

                // As bin goes from 12 to 755, binXFactor6 goes from 0.0 to 1.0
                let peakHueTemp = 6.0 * noteProc.binXFactor6[binNumData[peakNum]]       // All "C" notes are red.
                let peakHue = peakHueTemp.truncatingRemainder(dividingBy: 1)            // All "C" notes are red.

                let result = HtoRGB(hueValue: peakHue)
                let r1 = result.redValue
                let g1 = result.greenValue
                let b1 = result.blueValue
                let strokeColor4: CGColor = CGColor(red: r1, green: g1, blue: b1, alpha: 1.0)
                context?.setStrokeColor( strokeColor4 )
                context?.setLineWidth(4.0)
                context?.strokePath()
            }

        }  // end of for(peakNum) loop

        Pane.counter = ( Pane.counter < Pane.myHistCount ) ? Pane.counter + 1 : 0
        Pane.cgImage = context?.makeImage()!
        return ( Pane.cgImage! )        // A new cgImage is returned to the PeaksSpectrogram View 60 times per second.

    }  // end of DrawLine() func

}  // end of Pane struct


// TODO: New File
extension CGColor {
    static let black = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
    static let white = CGColor(red: 1, green: 1, blue: 1, alpha: 1)
}
