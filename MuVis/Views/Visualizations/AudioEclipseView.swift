/*
 AudioEclipseView.swift
 MuVis

 Created by Treata Norouzi on 4/14/24.
 
 Abstract:
 The AudioEclipse AudioVisualization shader from iShader library
*/

import AudioVisualizer
import SwiftUI

struct AudioEclipseView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            TimelineView(.animation(minimumInterval: 0.03)) { context in
                let elapsedTime = startTime.distance(to: context.date)
                
                AudioEclipse(time: elapsedTime, fft: audioManager.muSpectrum)
                    .overlay {
                        Circle()
                            .foregroundStyle(.thinMaterial)
                            .preferredColorScheme(.dark)
                            .frame(width: min(size.width, size.height) * 0.7)
                            .blur(radius: 15)
                            .shadow(radius: 15, x: 0, y: 0)
                    }
            }
        }
    }
}

#Preview("AudioEclipseView") { AudioEclipseView().enhancedPreview() }
