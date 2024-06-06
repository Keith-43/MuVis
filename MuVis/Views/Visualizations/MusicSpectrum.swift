///  MusicSpectrum.swift
///  MuVis
///
/// This view renders a visualization of the simple one-dimensional spectrum (using a mean-square amplitude scale) of the music. However, the horizontal scale is
/// rendered logarithmically to account for the logarithmic relationship between spectrum bins and musical octaves.  The spectrum covers 6 octaves from
/// leftFreqC1 = 32 Hz to rightFreqB8 = 2033 Hz -  that is from bin = 12 to bin = 755.
///
/// This visualization is identical to the Spectrum file except that the horizontal axis is specified by settings.binXFactor6[bin]
///
/// In the lower plot, the vertical axis shows (in red) the mean-square amplitude of the instantaneous spectrum of the audio being played. The red peaks are spectral
/// lines depicting the harmonics of the musical notes being played. The blue curve is a smoothed average of the red curve (computed by the findMean function
/// within the SpectralEnhancer class).  The blue curve typically represents percussive effects which smear spectral energy over a broad range.
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

/// Created by Keith Bromley on 4 Nov 2021. Improved in May 2023.

import SwiftUI


struct MusicSpectrum: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    var body: some View {
        let option = settings.option                // Use local short name to improve code readablity.
        ZStack {
            if( option < 4 ) { GrayVertRectangles(columnCount: 72) }                // struct code in VisUtilities file
            if( option < 4 ) { HorizontalNoteNames(rowCount: 2, octavesPerRow: 6) } // struct code in VisUtilities file
            MusicSpectrum_Live()
            if( option==1 || option==2 || option==5 || option==6 )  { MusicSpectrumPeaks(octaveCount: 6) }
            if( option==3 || option==4 ) { Notes(noteCount: 72) }
        }
    }
}

#Preview("MusicSpectrum") {
    MusicSpectrum()
        .enhancedPreview()
}

// MARK: - MusicSpectrum_Live

private struct MusicSpectrum_Live: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    let spectralEnhancer = SpectralEnhancer()
    let noteProc = NoteProcessing()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {

        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        let option = settings.option            // Use local short name to improve code readablity.
        
        GeometryReader { geometry in
            
            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            let halfHeight: CGFloat = height * 0.5
            let spectrumHeight: CGFloat = (option==0 || option==1 || option==4 || option==5) ? 0.9*halfHeight : 0.95*height
            
            var x: CGFloat = 0.0         // The drawing origin is in the upper left corner.
            var y: CGFloat = 0.0         // The drawing origin is in the upper left corner.
            var magY: CGFloat = 0.0      // used as a preliminary part of the "y" value

            // Use local short name to improve code readablity:
            let spectrum = manager.spectrum
            let meanSpectrum = spectralEnhancer.findMean(inputArray: spectrum)
            let decibelSpectrum = ampToDecibels(inputArray: spectrum)
            let meanDecibelSpectrum = spectralEnhancer.findMean(inputArray: decibelSpectrum)
            
            // We will render the spectrum bins from 12 to 755 - that is the 6 octaves from 32 Hz to 2,033 Hz.
            let lowerBin: Int = noteProc.octBottomBin[0]    // render the spectrum bins from 12 to 755
            let upperBin: Int = noteProc.octTopBin[5]       // render the spectrum bins from 12 to 755
            
            // ---------------------------------------------------------------------------------------------------------
            // First, render the rms amplitude spectrum in red in the lower half pane:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: height - ( CGFloat(spectrum[lowerBin]) * spectrumHeight ) ) )
                
                for bin in lowerBin ... upperBin {
                    x = width * noteProc.binXFactor6[bin]
                    magY = CGFloat(spectrum[bin]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.red)

            // Second, render the mean of the rms amplitude spectrum in blue:
            Path { path in
                path.move(to: CGPoint( x: 0.0, y: height - ( CGFloat(meanSpectrum[lowerBin]) * spectrumHeight ) ) )
                
                for bin in lowerBin ... upperBin {
                    x = width * noteProc.binXFactor6[bin]
                    magY = CGFloat(meanSpectrum[bin]) * spectrumHeight
                    magY = min(max(0.0, magY), spectrumHeight)
                    y = height - magY
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(lineWidth: 2.0)
            .foregroundColor(.blue)

// ---------------------------------------------------------------------------------------------------------------------
            if(option==0 || option==1 || option==4 || option==5) {
                // Third, render the decibel-scale spectrum in green in the upper half pane:
                Path { path in
                    path.move(to: CGPoint( x: 0.0, y: halfHeight - ( CGFloat(decibelSpectrum[lowerBin]) * halfHeight ) ) )
                    
                    for bin in lowerBin ... upperBin {
                        x = width * noteProc.binXFactor6[bin]
                        magY = CGFloat(decibelSpectrum[bin]) * halfHeight
                        magY = min(max(0.0, magY), halfHeight)
                        y = halfHeight - magY
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(lineWidth: 2.0)
                .foregroundColor(.green)
                
                
                // Fourth, render the mean of the decibel-scale spectrum in blue:
                Path { path in
                    path.move(to: CGPoint( x: 0.0, y: halfHeight - (CGFloat(meanDecibelSpectrum[lowerBin]) * halfHeight)))
                    
                    for bin in lowerBin ... upperBin {
                        x = width * noteProc.binXFactor6[bin]
                        magY = CGFloat(meanDecibelSpectrum[bin]) * halfHeight
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
}  // end of MusicSpectrum_Live struct

#Preview("MusicSpectrum_Live") {
    MusicSpectrum_Live()
        .enhancedPreview()
}

// MARK: - MusicSpectrumPeaks

struct MusicSpectrumPeaks: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    var noteProc = NoteProcessing()
    var octaveCount: Int

    var body: some View {
        Canvas(rendersAsynchronously: true) { context, size in
            let width: CGFloat  = size.width
            let height: CGFloat = size.height
            let halfHeight: CGFloat = height * 0.5
            var x: CGFloat = 0.0

            for peakNum in 0 ..< peakCount {                                            // peakCount = 16
                if(octaveCount == 3) { x = width * noteProc.binXFactor3[manager.peakBinNumbers[peakNum]] }
                if(octaveCount == 6) { x = width * noteProc.binXFactor6[manager.peakBinNumbers[peakNum]] }
                if(octaveCount == 8) { x = width * noteProc.binXFactor8[manager.peakBinNumbers[peakNum]] }
                context.fill(
                    Path(CGRect(x: x, y: 0.0, width: 2.0, height: 0.1 * halfHeight)),
                    with: .color((colorScheme == .light) ? .black : .white) )
                if( settings.option==0 || settings.option==1 || settings.option==4 || settings.option==5 ) {
                    context.fill(
                        Path(CGRect(x: x, y: halfHeight, width: 2.0, height: 0.1 * halfHeight)),
                        with: .color((colorScheme == .light) ? .black : .white) )
                }
            }
        }
    }
}

#Preview("MusicSpectrumPeaks") {
    MusicSpectrumPeaks(octaveCount: 6)
        .enhancedPreview()
}
