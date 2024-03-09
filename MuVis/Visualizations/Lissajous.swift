/// Lissajous.swift
/// MuVis
///
///  The Lissajous visualization takes advantage of the PeaksSorter class, and renders a separate Lissajous figure for each pair of loud spectral peaks.
///
/// I have long sought to develop a music-visualization scheme that readily displays the harmonic relationship of the frequencies being played. My inspiration comes
/// from Lissajous figures generated by applying sinusoidal waveforms to the vertical and horizontal inputs of an oscilloscope. Inputs of the same frequency generate
/// elliptical curves (including circles and lines). Inputs of different frequencies, where one is an integer multiple of the other, generate "twisted" ellipses.
/// A frequency ratio of 3:1 produces a "twisted ellipse" with 3 major lobes. A frequency ratio of 5:4 produces a curve with 5 horizontal lobes and 4 vertical lobes.
/// Such audio visualizations are both aesthetically pleasing and highly informative.
///
/// Over the past several years, I have implemented many many such visualizations and applied them to analyzing music. Unfortunately, most suffered from being
/// overly complex, overly dynamic, and uninformative. In my humble opinion, this Harmonograph visualization strikes the right balance between simplicity (i.e., the
/// ability to appreciate the symmetry of harmonic relationships) and dynamics that respond promptly to the music.
///
/// The wikipedia article at https://en.wikipedia.org/wiki/Harmonograph describes a double pendulum apparatus, called a Harmonograph, that creates
/// Lissajous figures from mixing two sinusoidal waves of different frequencies and phases. This Harmonograph visualization uses just the two loudest spectrum
/// peaks to produce the Lissajous figure. That is, the loudest peak generates a sine wave of its frequency to drive the horizontal axis of our visual oscilloscope,
/// and the second-loudest peak generates a sine wave of its frequency to drive the vertical axis.
///
/// The Lissajous visualization uses spectral peaks selected from the spectrum[bin] input data.
///
// option0  15Lissajous  notBasebanded
// option1  10Lissajous  notBasebanded
// option2  6Lissajous   notBasebanded
// option3  3Lissajous   notBasebanded
// option4  15Lissajous  basebanded
// option5  10Lissajous  basebanded
// option6  6Lissajous   basebanded
// option7  3Lissajous   basebanded

/// Created by Keith Bromley on 1 Aug 2022.  Modified in May 2023.

import SwiftUI


struct Lissajous : View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    var peaksSorter = PeaksSorter()
    
    var body: some View {
        
        let option = settings.option     // Use local short name to improve code readablity.
        
        Canvas { context, size in

            let width: Double  = size.width
            let height: Double = size.height
            let halfWidth : Double  = width * 0.5
            let halfHeight : Double = height * 0.5
            let dataLength: Int = 1000                   // Looks aesthetically pleasing

            var x : Double = 0.0       // The drawing origin is in the upper left corner.
            var y : Double = 0.0       // The drawing origin is in the upper left corner.

            let now = Date()  // Contains the date and time of the start of each frame of audio data.
            let seconds:Double = now.timeIntervalSinceReferenceDate

            var angle: Double = 0.0
            var oldAngle: Double = 0.0
            let peakCount: Int = ( option == 0 || option == 4 ) ? 5 :
                                 ( option == 1 || option == 5 ) ? 4 :
                                 ( option == 2 || option == 6 ) ? 3 : 2

            var peaks: Int = 0                              // peaks counter    0 <= peaks < peaksMax   // used for hue

            let peaksMax: Int = ( option == 0 || option == 4 ) ? 15 :           // 15 = 5+4+3+2+1       // used for hue
                                ( option == 1 || option == 5 ) ? 10 :           // 10 = 4+3+2+1         // used for hue
                                ( option == 2 || option == 6 ) ?  6 : 3         // 6 = 3+2+1  3 = 2+1   // used for hue

            var binNumber: [Int]    = [Int](repeating: 0, count: peakCount)
            var frequency: [Double] = [Double](repeating: 0.0, count: peakCount)
            var amplitude: [Double] = [Double](repeating: 0.0, count: peakCount)
            
            for peakNum in 0 ..< peakCount {
                binNumber[peakNum] = manager.peakBinNumbers[peakNum]
                frequency[peakNum] = Double(manager.peakBinNumbers[peakNum]) * AudioManager.binFreqWidth
                amplitude[peakNum] = Double(manager.peakAmps[peakNum])
            }

            if( option > 3 ) {             // Baseband the frequencies.
                for peakNum in 0 ..< peakCount {        // octBottomBin = 12, 24, 48,  95, 189, 378,  756
                    if(      binNumber[peakNum] > 378) { frequency[peakNum] = frequency[peakNum] / 32.0 }
                    else if (binNumber[peakNum] > 189) { frequency[peakNum] = frequency[peakNum] / 16.0 }
                    else if (binNumber[peakNum] >  95) { frequency[peakNum] = frequency[peakNum] /  8.0 }
                    else if (binNumber[peakNum] >  48) { frequency[peakNum] = frequency[peakNum] /  4.0 }
                    else if (binNumber[peakNum] >  24) { frequency[peakNum] = frequency[peakNum] /  2.0 }
                }
            }

            // Declare peakCount waveforms - each of length dataLength.  This array contains 4*1000*8 = 32,000 bytes.
            var waveform: [[Double]] = Array(repeating: Array(repeating: 0.0, count: dataLength), count: peakCount)

            // Now generate a sinusoidal waveform for each of the loudest 5 of these peaks:
            for peakNum in 0 ..< peakCount {
                oldAngle = seconds * frequency[peakNum]

                for i in 0 ..< dataLength {
                    angle = oldAngle + ( 2.0 * Double.pi * Double(i) * frequency[peakNum]  / AudioManager.sampleRate )
                    waveform[peakNum][i] = 0.2 * amplitude[peakNum] * sin(angle)
                }
            }

            // Finally, generate Lissajous figures from these waveforms:
            for peakNum1 in 0 ..< peakCount {

                // Only render a Lissajous figure for non-zero peaks.
                if(amplitude[peakNum1] == 0.0) {continue}

                // Compare each peak with each lesser peak:
                for peakNum2 in peakNum1+1 ..< peakCount {

                    let hue: Double = Double(peaks) / Double(peaksMax)  // hue = 0.0  0.16  0.33  0.5  0.67  0.83
                    // peaks += 1
                    peaks = (peaks >= peaksMax) ? 0 : peaks + 1

                    // Only render a Lissajous figure for non-zero peaks.
                    if(amplitude[peakNum2] == 0.0) {continue}

                    var path = Path()
                    x = halfWidth  + (halfWidth  * waveform[peakNum1][0])   // x coordinate of the zeroth sample
                    y = halfHeight - (halfHeight * waveform[peakNum2][0])   // y coordinate of the zeroth sample
                    path.move( to: CGPoint( x: x, y: y ) )

                    for sampleNum in 1 ..< dataLength {
                        x = halfWidth  + (halfWidth  * waveform[peakNum1][sampleNum])
                        y = halfHeight - (halfHeight * waveform[peakNum2][sampleNum])
                        x = min(max(0, x), width)
                        y = min(max(0, y), height)
                        path.addLine( to: CGPoint( x: x, y: y ) )
                    }
                    context.stroke( path,
                                    with: .color( Color(hue: hue, saturation: 1.0, brightness: 1.0) ),
                                    lineWidth: 2.0 )
                }
            }

            /*
             option == 0 || option == 4:
                PeakNum1:   0   0   0   0   0   1   1   1   1   2   2   2   3   3   4
                PeakNum2:   1   2   3   4   5   2   3   4   5   3   4   5   4   5   5
             option == 1 || option == 5:
                PeakNum1:   0   0   0   0   1   1   1   2   2   3
                PeakNum2:   1   2   3   4   2   3   4   3   4   4
             option == 2 || option == 6:
                PeakNum1:   0	0	0   1   1   2
                PeakNum2:   1	2	3   2   3   3
             option == 3 || option == 7:
                PeakNum1:   0   0   1
                PeakNum2:   1   2   2
            */

        }  // end of Canvas{}
        .background( colorScheme == .dark ? Color.black : Color.white )
        // Toggle between black and white as the Canvas's background color.

    }  // end of var body: some View
}  // end of Lissajous struct

#Preview("Lissajous") {
    Lissajous()
        .enhancedPreview()
}
