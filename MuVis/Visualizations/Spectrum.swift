///  Spectrum.swift
///  MuVis
///
/// This view renders a visualization of the simple one-dimensional spectrum (using a mean-square amplitude scale) of the music.
///
/// We could render a full Spectrum - that is, rendering all of the 8,192 bins -  covering a frequency range from 0 Hz on the left to about 44,100 / 2 = 22,050 Hz
/// on the right . But instead, we will render the spectrum bins from 12 to 755 - that is the 6 octaves from 32 Hz to 2,033 Hz.
///
/// In the lower plot, the horizontal axis is linear frequency (from 32 Hz on the left to 2,033 Hz on the right). This linearity means that we can use the bin number
/// instead of the frequency.  (i.e., One is just a constant times the other.)  So the horizontal axis goes from bin 12 on the left to bin 755 on the right.
/// The vertical axis shows (in red) the mean-square amplitude of the instantaneous spectrum of the audio being played. The red peaks are spectral lines depicting
/// the harmonics of the musical notes being played. The blue curve is a smoothed average of the red curve (computed by the findMean function within the
/// SpectralEnhancer class). The blue curve typically represents percussive effects which smear spectral energy over a broad range.
///
/// The upper plot (in green) is the same as the lower plot except the vertical scale is decibels (over an 80 dB range) instead of the mean-square amplitude.
/// This more closely represents what the human ear actually hears.
///
/// Clicking on the Option button adds a piano-keyboard overlay . Note that the keyboard has been purposely distorted in order to represent musical notes
/// on the linear frequency of the plot.  This graphically illustrates the difference between the linear-frequency spectrum produced by the FFT and th
/// logarithmic-frequency spectrum used in music.
///
/// Clicking the Option button also adds small rectangles denoting the real-time spectral peaks.  These move very dynamically since the peak amplitudes change
/// very rapidly from frame-to-frame of the audio.  Displaying them here gives me confidence that they are computed properly.  These peaks concisely capture the
/// melody and harmony of the music.
///
//          background  foreground
// option0  keyboard    spectrum&decibels
// option1  keyboard    spectrum&decibels       peaks
// option2  keyboard    spectrum                peaks
// option3  keyboard    spectrum
// option4  plain       spectrum&decibels
// option5  plain       spectrum&decibels       peaks
// option6  plain       spectrum                peaks
// option7  plain       spectrum
//
/// Created by Keith Bromley on 20 Nov 2020.  Significantly updated on 28 Oct 2021.  Modiefied on 8 May 2023.

import SwiftUI



struct Spectrum: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    var body: some View {
        let option = settings.option     // Use local short name to improve code readablity.
        ZStack {
            if( option < 4 ) { GrayVertRects() }
            Spectrum_Live()
            if( option==0 || option==1 || option==4 || option==5 ) { DecibelSpectrum_Live() }
            if( option==1 || option==2 || option==5 || option==6 ) { SpectrumPeaks() }
        }
    }
}



struct Spectrum_Live: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    let spectralEnhancer = SpectralEnhancer()
    let noteProc = NoteProcessing()
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
            
            var x: CGFloat = 0.0        // The drawing origin is in the upper left corner.
            var y: CGFloat = 0.0        // The drawing origin is in the upper left corner.
            var upRamp: CGFloat = 0.0
            var magY: CGFloat = 0.0             // used as a preliminary part of the "y" value
            
            // Use local short name to improve code readablity:
            let spectrum = manager.spectrum
            let meanSpectrum = spectralEnhancer.findMean(inputArray: spectrum)
            
            // We will render the spectrum bins from 12 to 755 - that is the 6 octaves from 32 Hz to 2,033 Hz.
            let lowerBin: Int = noteProc.octBottomBin[0]    // render the spectrum bins from 12 to 755
            let upperBin: Int = noteProc.octTopBin[5]       // render the spectrum bins from 12 to 755
            
// ---------------------------------------------------------------------------------------------------------------------
            // First, render the rms amplitude spectrum in red in the lower half pane:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: height - ( CGFloat(spectrum[lowerBin]) * spectrumHeight ) ) )
                
                for bin in lowerBin ... upperBin {
                    // upRamp goes from 0.0 to 1.0 as bin goes from lowerBin to upperBin:
                    upRamp =  Double(bin - lowerBin) / Double(upperBin - lowerBin)
                    x = upRamp * width
                    magY = CGFloat(spectrum[bin]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.red)
            .background( Color.clear )
            
            // Second, render the mean of the rms amplitude spectrum in blue:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: height - ( CGFloat(meanSpectrum[lowerBin]) * spectrumHeight) ) )
                
                for bin in lowerBin ... upperBin {
                    // upRamp goes from 0.0 to 1.0 as bin goes from lowerBin to upperBin:
                    upRamp =  Double(bin - lowerBin) / Double(upperBin - lowerBin)
                    x = upRamp * width
                    magY = CGFloat(meanSpectrum[bin]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.blue)
            .background( Color.clear )

        }  // end of GeometryReader
        .background( ( option > 3 ) ? backgroundColor : Color.clear )
        
    }  // end of var body: some View
}  // end of Spectrum_Live struct



struct DecibelSpectrum_Live: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    let spectralEnhancer = SpectralEnhancer()
    let noteProc = NoteProcessing()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            let halfHeight: CGFloat = height * 0.5
            
            var x: CGFloat = 0.0        // The drawing origin is in the upper left corner.
            var y: CGFloat = 0.0        // The drawing origin is in the upper left corner.
            var upRamp: CGFloat = 0.0
            var magY: CGFloat = 0.0             // used as a preliminary part of the "y" value

            let decibelSpectrum = ampToDecibels(inputArray: manager.spectrum)
            let meanDecibelSpectrum = spectralEnhancer.findMean(inputArray: decibelSpectrum)
            
            // We will render the spectrum bins from 12 to 755 - that is the 6 octaves from 32 Hz to 2,033 Hz.
            let lowerBin: Int = noteProc.octBottomBin[0]    // render the spectrum bins from 12 to 755
            let upperBin: Int = noteProc.octTopBin[5]       // render the spectrum bins from 12 to 755
            
            // First, render the decibel-scale spectrum in green in the upper half pane:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: halfHeight - ( CGFloat(decibelSpectrum[lowerBin]) * halfHeight ) ) )
                
                for bin in lowerBin ... upperBin {
                    // upRamp goes from 0.0 to 1.0 as bin goes from lowerBin to upperBin:
                    upRamp =  Double(bin - lowerBin) / Double(upperBin - lowerBin)
                    x = upRamp * width
                    magY = CGFloat(decibelSpectrum[bin]) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.green)
            .background( Color.clear )
            
            // Second, render the mean of the decibel-scale spectrum in blue:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: halfHeight - ( CGFloat(meanDecibelSpectrum[lowerBin]) * halfHeight ) ) )
                
                for bin in lowerBin ... upperBin {
                    // upRamp goes from 0.0 to 1.0 as bin goes from lowerBin to upperBin:
                    upRamp =  Double(bin - lowerBin) / Double(upperBin - lowerBin)
                    x = upRamp * width
                    magY = CGFloat(meanDecibelSpectrum[bin]) * halfHeight
                    magY = min(max(0.0, magY), halfHeight)
                    y = halfHeight - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.blue)
            .background( Color.clear )

        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of DecibelSpectrum_Live struct



// Render the peaks in black or white at the top of the view:
struct SpectrumPeaks: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    
    var body: some View {
        Canvas { context, size in
            let width: Double  = size.width
            let height: Double = size.height
            let halfHeight: Double = height * 0.5
            var x : Double = 0.0
            let lowerBin: Int = noteProc.octBottomBin[0]    // render the spectrum bins from 12 to 755
            let upperBin: Int = noteProc.octTopBin[5]       // render the spectrum bins from 12 to 755

            for peakNum in 0 ..< peakCount {   // peaksSorter.peakCount = 16
                 x = width * ( Double(manager.peakBinNumbers[peakNum] - lowerBin) / Double(upperBin - lowerBin) )
                context.fill(
                    Path(CGRect(x: x, y: 0.0, width: 2.0, height: 0.1 * halfHeight)),
                    with: .color((colorScheme == .light) ? .black : .white) )
                if( settings.option==1 || settings.option==5 ) {
                    context.fill(
                        Path(CGRect(x: x, y: halfHeight, width: 2.0, height: 0.1 * halfHeight)),
                        with: .color((colorScheme == .light) ? .black : .white) )
                }
            }
        }
    }
}  // end of SpectrumPeaks struct



// The ampToDecibels() func is used in the Spectrum and MusicSpectrum visualizations.
public func ampToDecibels(inputArray: [Float]) -> ([Float]) {
    var dB: Float = 0.0
    let dBmin: Float =  1.0 + 0.0125 * 20.0 * log10(0.001)
    var amplitude: Float = 0.0
    var outputArray: [Float] = [Float] (repeating: 0.0, count: inputArray.count)

    // I must raise 10 to the power of -4 to get my lowest dB value (0.001) to 20*(-4) = 80 dB
    for bin in 0 ..< inputArray.count {
        amplitude = inputArray[bin]
        if(amplitude < 0.001) { amplitude = 0.001 }
        dB = 20.0 * log10(amplitude)    // As 0.001  < spectrum < 1 then  -80 < dB < 0
        dB = 1.0 + 0.0125 * dB          // As 0.001  < spectrum < 1 then    0 < dB < 1
        dB = dB - dBmin
        dB = min(max(0.0, dB), 1.0)
        outputArray[bin] = dB
    }
    return outputArray
}



struct GrayVertRects: View {
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    
    var body: some View {
        GeometryReader { geometry in
            let width: Double  = geometry.size.width
            let height: Double = geometry.size.height
            let octaveCount = 6

            ForEach( 0 ..< octaveCount, id: \.self) { oct in        //  0 <= oct < 6

                ForEach( 0 ..< notesPerOctave, id: \.self) { note in        //  0 <= note < 12

                    let cumulativeNotes: Int = oct * notesPerOctave + note  // cumulativeNotes = 0, 1, 2, 3, ... 71

                    if(accidentalNotes[note] == true) {
                        // The accidentalNotes array is a global variable declared in MuVisApp.swift
                        // This condition selects the column values for the notes C#, D#, F#, G#, and A#.

                        let leftNoteFreq: Float  = noteProc.leftFreqC1  * pow(noteProc.twelfthRoot2, Float(cumulativeNotes) )
                        let rightFreqC1: Float   = noteProc.freqC1 * noteProc.twentyFourthRoot2
                        let rightNoteFreq: Float = rightFreqC1 * pow(noteProc.twelfthRoot2, Float(cumulativeNotes) )

                        // The x-axis is frequency (in Hz) and covers the 6 octaves from 32 Hz to 2,033 Hz.
                        var x: Double = width * ( ( Double(leftNoteFreq) - 32.0 ) / (2033.42 - 32.0) )

                        Path { path in
                            path.move(   to: CGPoint( x: x, y: height ) )
                            path.addLine(to: CGPoint( x: x, y: 0.0))

                            x = width * ( ( Double(rightNoteFreq) - 32.0 ) / (2033.42 - 32.0) )

                            path.addLine(to: CGPoint( x: x, y: 0.0))
                            path.addLine(to: CGPoint( x: x, y: height))
                            path.closeSubpath()
                        }
                        .foregroundColor( colorScheme == .light ?
                                          .lightGray :
                                          .black )
                    }
                }
            }
        }
    }
}  // end of struct GrayVertRects
