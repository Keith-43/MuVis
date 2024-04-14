///  Spectrogram.swift
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
///  This is a spectrogram using CGContext from Core Graphics.
///
//           foreground     color       background
//  option0  stationary     valueColor  keyboard
//  option1  stationary     valueColor  plain
//  option2  stationary     noteColor   keyboard
//  option3  stationary     noteColor   plain
//  option4  scroll         valueColor  keyboard
//  option5  scroll         valueColor  plain
//  option6  scroll         noteColor   keyboard
//  option7  scroll         noteColor   plain
///
/// Created by Keith Bromley on 26 August 2023.

import SwiftUI



struct MuSpectrogramCG: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.displayScale) var displayScale: CGFloat
    @Environment(\.colorScheme) var colorScheme
    
    @State private var drawingPane = DrawingPane()

    var body: some View {
        let option = settings.option

        ZStack {
            Image(decorative: drawingPane.drawLine( data: manager.muSpectrum, scheme: colorScheme, option: option),
                  scale: displayScale,
                  orientation: .up
            )
            .resizable()
            VerticalNoteNames(columnCount: 2, octavesPerColumn: 6)
        }
    }
}

#Preview("MuSpectrogramCG") {
    MuSpectrogramCG()
        .enhancedPreview()
}

// MARK: - DrawingPane

private struct DrawingPane {
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

    let width  = Double( DrawingPane.myHistCount )              // width  = 1_000.0
    let height = Double( sixOctPointCount )                     // height =   864.0
    let columnWidth: Double = 1.0
    let rowHeight: Double = 1.0

    func drawLine( data: [Float], scheme: ColorScheme, option: Int ) -> CGImage {

        // Fill drawing pane with white or black at start of every spectrogram screen:
        if( DrawingPane.counter == 0 ) {
            let fillColor: CGColor = (scheme == .light) ? .white : .black
            context?.setFillColor(fillColor)
            context?.fill( CGRect( x: 0.0, y: 0.0, width: width, height: height ) )
        }
        
        var showKeyboard: Bool = true   // If true, a keyboard is rendered in place of low-amplitude spectral points.
        var valueColor: Bool = true     // If true, the color is based upon the spectral value of that point.
        var scroll: Bool = false        // If true, the spectrogram scrolls across the screen.
        
        if(option==4 || option==5 || option==6 || option==7) {scroll = true}       else {scroll = false}
        if(option==0 || option==1 || option==4 || option==5) {valueColor = true}   else {valueColor = false}
        if(option==0 || option==2 || option==4 || option==6) {showKeyboard = true} else {showKeyboard = false}

        var fractionX: Double = 0.0

        if( scroll == true ) { fractionX = 1.0 }
        else { fractionX = Double( DrawingPane.counter ) / Double( DrawingPane.myHistCount ) } // 0.0 <= fractionX <= 1.0

        if( scroll == true ) {
            let translatedRect = CGRect( x: -1.0, y: 0.0, width: width, height: height )

            // Render the recursively-translated previous spectral lines into the context:
            if DrawingPane.cgImage != nil {       // The first pass through this recursive loop will have cgImage = nil.
                context?.draw(DrawingPane.cgImage!, in: translatedRect) // context is translated to fit into the rectangle
            }
        }

        let threshold: Double = 0.1     // pointValues below this threshold will show keyboard instead of muSpectrogram.
        let inverseThreshold: Double = 1.0 / (1.0 - threshold)

        context?.beginPath()
        for octave in 0 ..< octaveCount {                                                   // 0 <= octave < 6
            for note in 0 ..< notesPerOctave {                                              // 0 <= note < 12
                for point in 0 ..< pointsPerNote {                                          // 0 <= point < 12
                    let point1 = (octave*pointsPerOctave) + (note*pointsPerNote) + point    // 0 <= point1 < 864

                    let pointValue = Double( data[point1] )
                    let value1 = min( max(threshold, pointValue), 1.0 )         // clip value to range 0.1 ... 1.0
                    let value2 = (value1 - threshold) * inverseThreshold        // expand value1 to range 0.0 ... 1.0
                    let value3 = (scheme == .light) ? value2 : 1.0 - value2

                    let fractionY  = Double( point1     ) / Double( sixOctPointCount )
                    let fractionY1 = Double( point1 + 1 ) / Double( sixOctPointCount )
                    context?.move(   to: CGPoint( x: width * fractionX, y: height * fractionY  ) )
                    context?.addLine(to: CGPoint( x: width * fractionX, y: height * fractionY1 ) )

                    if( pointValue < threshold ) {   // pointValue is below the threshold
                    
                        if( showKeyboard == true ) {
                            if (accidentalNotes[note] == true) {                         // accidental notes
                                let strokeColor1: CGColor = ( scheme == .dark ?
                                                              CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) :  // black
                                                              CGColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0) )  // light gray
                                context?.setStrokeColor( strokeColor1 )
                                context?.strokePath()
                            } else {                                                    // natural notes
                                let strokeColor2: CGColor = ( scheme == .dark ?
                                                              CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0) :  // dark gray
                                                              CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )  // white
                                context?.setStrokeColor( strokeColor2 )
                                context?.strokePath()
                            }
                        }else{
                            let strokeColor3: CGColor = ( scheme == .dark ?
                                                          CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) :  // black
                                                          CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) )  // white
                            context?.setStrokeColor( strokeColor3 )
                            context?.strokePath()
                        }

                    } else {                    // pointValue is above the threshold

                        if( valueColor == true ) {        // The color is based upon the spectral value of that point.
                            let result = HtoRGB_WRYGCBB(hueValue: value3)
                            let r = result.redValue
                            let g = result.greenValue
                            let b = result.blueValue
                            let strokeColor4: CGColor = CGColor(red: r, green: g, blue: b, alpha: 1.0)
                            context?.setStrokeColor( strokeColor4 )
                            context?.strokePath()

                        } else {                        // The color is based upon the spectral position of that point.
                            let pointWithinOctave: Int = ( note * pointsPerNote ) + point
                            let pointHue: Double = Double(pointWithinOctave) / Double(pointsPerOctave) // 0.0 <= pointHue < 1.0
                            let result1 = HtoRGB(hueValue: pointHue)
                            let r1 = result1.redValue
                            let g1 = result1.greenValue
                            let b1 = result1.blueValue
                            let strokeColor5: CGColor = CGColor(red: r1, green: g1, blue: b1, alpha: 1.0)
                            context?.setStrokeColor( strokeColor5 )
                            context?.strokePath()

                        }
                    }  // end of "pointValue is above the threshold"

                }  // end of for(point) loop
            }  // end of for(note) loop
        }  // end of for(octave) loop

        DrawingPane.counter = ( DrawingPane.counter <= DrawingPane.myHistCount ) ? DrawingPane.counter + 1 : 0
        DrawingPane.cgImage = context?.makeImage()!
        return ( DrawingPane.cgImage! )  // A new cgImage is returned to the SpectrogramCG View 60 times per second.

    }  // end of DrawLine() func

}  // end of DrawingPane struct
