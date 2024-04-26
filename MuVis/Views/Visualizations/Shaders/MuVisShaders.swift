/*
 MuVisShaders.swift
 MuVis

 Created by Treata Norouzi on 4/26/24.
 
 Abstract:
 The Views in which AudioVisualizer shaders from the iShader library are demonstrated
*/

import AudioVisualizer
import SwiftUI

// !!!: Demoware WIP

// MARK: - Audio Eclipse

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

#Preview("Audio Eclipse") { AudioEclipseView().enhancedPreview() }

// MARK: - Sine Sound Waves

struct SineSoundWavesView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.03)) { context in
            let elapsedTime = startTime.distance(to: context.date)
            
            SineSoundWaves(time: elapsedTime, fft: audioManager.muSpectrum)
        }
    }
}

#Preview("Sine Sound Waves") { SineSoundWavesView().enhancedPreview() }

// MARK: - Glowing Sound Particles

struct GlowingSoundParticlesView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.03)) { context in
            let elapsedTime = startTime.distance(to: context.date)
            
            GlowingSoundParticles(time: elapsedTime, fft: audioManager.muSpectrum)
        }
    }
}

#Preview("Glowing Sound Particles") { GlowingSoundParticlesView().enhancedPreview() }

// MARK: - Universe Within

struct UniverseWithinView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    @State private var touch = CGPoint.zero
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.03)) { context in
            let elapsedTime = startTime.distance(to: context.date)
            
            UniverseWithin(
                time: elapsedTime,
                fft: audioManager.spectrum,
                location: touch
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { self.touch = $0.location }
            )
        }
    }
}

#Preview("Universe Within") { UniverseWithinView().enhancedPreview() }

// MARK: - Galaxy Visuals

struct GalaxyVisualsView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.03)) { context in
            let elapsedTime = startTime.distance(to: context.date)
            
            GalaxyVisuals(time: elapsedTime, fft: audioManager.muSpectrum)
        }
    }
}

#Preview("Galaxy Visuals") { GalaxyVisualsView().enhancedPreview() }

// MARK: - Round Audio Specturm

struct RoundAudioSpecturmView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        RoundAudioSpecturm(
            fft: audioManager.muSpectrum,
            backgroundColor: .black,
            rayCount: 98
        )
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview("Round Audio Specturm") { RoundAudioSpecturmView().enhancedPreview() }

// MARK: - Waves Remix

struct WavesRemixView: View {
    @Environment(AudioManager.self) var audioManager
    
    @State private var startTime: Date = .now
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 0.03)) { context in
            let elapsedTime = startTime.distance(to: context.date)
            
            WavesRemix(time: elapsedTime, fft: audioManager.muSpectrum)
        }
    }
}

#Preview("Waves Remix") { WavesRemixView().enhancedPreview() }
