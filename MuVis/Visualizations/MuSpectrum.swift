/// MuSpectrum.swift
/// MuVis
///
/// This view renders a visualization of the muSpectrum (using a mean-square amplitude scale) of the music. I have coined the name muSpectrum for the
/// exponentially-resampled version of the spectrum to more closely represent the notes of the musical scale.
///
/// In the lower plot, the horizontal axis is exponential frequency - from the note C1 (about 33 Hz) on the left to the note B7 (about 3,951 Hz) on the right.
/// The vertical axis shows (in red) the mean-square amplitude of the instantaneous muSpectrum of the audio being played. The red peaks are spectral lines
/// depicting the harmonics of the musical notes being played - and cover seven octaves. The blue curve is a smoothed average of the red curve (computed by the
/// findMean function within the SpectralEnhancer class). The blue curve typically represents percussive effects which smear spectral energy over a broad range.
///
/// The upper plot (in green) is the same as the lower plot except the vertical scale is decibels (over an 80 dB range) instead of the mean-square amplitude.
/// This more closely represents what the human ear actually hears.
///
//          background  foreground
// option0  keyboard    spectrum&decibels
// option1  keyboard    spectrum&decibels       peaks
// option2  keyboard    spectrum                peaks
// option3  keyboard    spectrum                notes
// option4  plain       spectrum&decibels       notes
// option5  plain       spectrum&decibels       peaks
// option6  plain       spectrum                peaks
// option7  plain       spectrum
///
/// Created by Keith Bromley on 20 Nov 2020.  Modified in May 2023.

import SwiftUI



struct MuSpectrum: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    var body: some View {
        let option = settings.option     // Use local short name to improve code readablity.
        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 96) }                // struct code in VisUtilities file
            if( option < 4 ) { HorizontalNoteNames(rowCount: 2, octavesPerRow: 8) } // struct code in VisUtilities file
            MuSpectrum_Live()
            if( option==1 || option==2 || option==5 || option==6 ) { MusicSpectrumPeaks(octaveCount: 8) }
            if( option==3 || option==4 ) { Notes(noteCount: 96) }
        }
    }
}

#Preview("MuSpectrum") {
    MuSpectrum()
        .enhancedPreview()
}

// MARK: - MuSpectrum_Live

private struct MuSpectrum_Live: View {

    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    let spectralEnhancer = SpectralEnhancer()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
    
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        let option = settings.option     // Use local short name to improve code readablity.
        
        GeometryReader { geometry in

            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            let halfHeight: CGFloat = height * 0.5
            let spectrumHeight: CGFloat = (option==0 || option==1 || option==4 || option==5) ? 0.9*halfHeight : 0.95*height
            
            var x: CGFloat = 0.0       // The drawing origin is in the upper left corner.
            var y: CGFloat = 0.0       // The drawing origin is in the upper left corner.
            var upRamp: CGFloat = 0.0
            var amplitude: Float = 0.0
            var dB: Float = 0.0
            let dBmin: Float =  1.0 + 0.0125 * 20.0 * log10(0.001)
            var magY: CGFloat = 0.0             // used as a preliminary part of the "y" value

            var meanMuSpectrum: [Float]     = [Float](repeating: 0.0, count: eightOctPointCount) // eightOctPointCount=96*12=1,152
            var dB_muSpectrum: [Float]      = [Float](repeating: 0.0, count: eightOctPointCount) // dB-scale muSpectrum
            var mean_dB_muSpectrum: [Float] = [Float](repeating: 0.0, count: eightOctPointCount) // mean of dB-scale muSpectrum

            // ---------------------------------------------------------------------------------------------------------
            // First, render the muSpectrum in red in the lower half pane:
            Path { path in
                path.move( to: CGPoint( x: CGFloat(0.0), y: height - CGFloat(manager.muSpectrum[0]) * spectrumHeight ) )

                for point in 0 ..< eightOctPointCount {
                    // upRamp goes from 0.0 to 1.0 as point goes from 0 to eightOctPointCount
                    upRamp =  CGFloat(point) / CGFloat(eightOctPointCount)
                    x = upRamp * width
                    magY = CGFloat(manager.muSpectrum[point]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.red)

            // Second, render the mean of the muSpectrum in blue:
            Path { path in
                meanMuSpectrum = spectralEnhancer.findMean(inputArray: manager.muSpectrum)
                path.move( to: CGPoint( x: CGFloat(0.0), y: height - CGFloat(meanMuSpectrum[0]) * spectrumHeight ) )
                
                for point in 1 ..< eightOctPointCount {
                    upRamp =  CGFloat(point) / CGFloat(eightOctPointCount)
                    // upRamp goes from 0.0 to 1.0 as point goes from 0 to eightOctPointCount
                    x = upRamp * width
                    magY = CGFloat(meanMuSpectrum[point]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.blue)
            
            // ---------------------------------------------------------------------------------------------------------
            if(option==0 || option==1 || option==4 || option==5) {
            // Third, render the decibel-scale muSpectrum in green in the upper half pane:
                Path { path in
                    path.move( to: CGPoint( x: CGFloat(0.0), y: halfHeight ) )
                        
                    for point in 0 ..< eightOctPointCount {
                        upRamp =  CGFloat(point) / CGFloat(eightOctPointCount)
                        // upRamp goes from 0.0 to 1.0 as point goes from 0 to eightOctPointCount
                        x = upRamp * width
                        
                        // I must raise 10 to the power of -4 to get my lowest dB value (0.001) to 20*(-4) = 80 dB
                        amplitude = manager.muSpectrum[point]
                        if(amplitude < 0.001) { amplitude = 0.001 }
                        dB = 20.0 * log10(amplitude)    // As 0.001  < spectrum < 1 then  -80 < dB < 0
                        dB = 1.0 + 0.0125 * dB          // As 0.001  < spectrum < 1 then    0 < dB < 1
                        dB = dB - dBmin
                        dB = min(max(0.0, dB), 1.0)
                        dB_muSpectrum[point] = dB           // We use this array below in creating the mean spectrum
                        magY = CGFloat(dB) * halfHeight
                        y = halfHeight - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(lineWidth: 2.0)
                .foregroundColor(.green)

                // Fourth, render the mean of the decibel-scale muSpectrum in blue:
                Path { path in
                    mean_dB_muSpectrum = spectralEnhancer.findMean(inputArray: dB_muSpectrum)
                    path.move( to: CGPoint( x: CGFloat(0.0), y: halfHeight - CGFloat(mean_dB_muSpectrum[0]) * halfHeight ) )
                    
                    for point in 0 ..< eightOctPointCount {
                        upRamp =  CGFloat(point) / CGFloat(eightOctPointCount)
                        // upRamp goes from 0.0 to 1.0 as point goes from 0 to eightOctPointCount
                        x = upRamp * width
                        magY = CGFloat(mean_dB_muSpectrum[point]) * halfHeight
                        magY = min(max(0.0, magY), halfHeight)
                        y = halfHeight - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(lineWidth: 2.0)
                .foregroundColor(.blue)
            }

        }  // end of GeometryReader
        .background( ( option > 3 ) ? backgroundColor : Color.clear )
        
    }  // end of var body: some View
}  // end of MuSpectrum struct

#Preview("MuSpectrum_Live") {
    MuSpectrum_Live()
        .enhancedPreview()
}

