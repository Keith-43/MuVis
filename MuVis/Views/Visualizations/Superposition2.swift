//  Superposition.swift
//  MuVis

//  In this visualization, for each frame of live audio data, we generate a sinusoidal waveform for each of it's 16 peak frequencies.  We then sum these 16 sinusoidal waveforms and render the resulting superposition.  We take care to ensure that the phase of each waveform starts at zero on the left side of the display pane.  So all of the 16 waveforms are jointly "in-phase".

//  One can think of this visualization as being an oscilloscope display of the original input audio waveform where all of the frequencies have been "magically" made to have a constant phase (instead of a chaotic wildly-dynamic phase which makes most oscilloscope types of display extremely difficult to interpret).

//  In the normal mode, the waveforms are 256 samples in length to show the fine detail of the superposition.

//  https://sarunw.com/posts/gradient-in-swiftui/#lineargradient
//
//  Created by Keith Bromley in April 2024.


import SwiftUI

struct Superposition2: View {
    @Environment(AudioManager.self) var manager  // Observe the instance of AudioManager passed from ContentView
    @Environment(Settings.self) var settings
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let myDataLength: Int = 256
        
        let sumWaveforms = generateWaveform(
            binNumbers: manager.peakBinNumbers,
            myDataLength: myDataLength
        )
        
        Canvas { context, size in
            
            let width: Double  = size.width
            let height: Double = size.height
            var x : Double = 0       // The drawing origin is in the upper left corner.
            var y : Double = 0       // The drawing origin is in the upper left corner.
            let halfHeight: Double = height * 0.5
            var upRamp: Double = 0
            var magY: Double = 0      // used as a preliminary part of the "y" value
            
            var path = Path()
            path.move(to: CGPoint(x: 0, y: halfHeight) )

            for sample in 0 ..< myDataLength {
                // upRamp goes from 0.0 to 1.0 as bin goes from lowerBin to upperBin:
                upRamp =  Double(sample) / Double(myDataLength)
                x = upRamp * width

                magY = Double(sumWaveforms[sample]) * halfHeight
                magY = min(max(-halfHeight, magY), halfHeight)
                y = halfHeight - magY
                path.addLine(to: CGPoint(x: x, y: y))
            }
            path.addLine(to: CGPoint(x: width, y: halfHeight))
            
            context.stroke(
                path,
                with: .color(Color.red),
                lineWidth: 3)
        }
    }
}

#Preview("Superposition2") { Superposition2().enhancedPreview() }
