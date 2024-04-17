/*
 AudioVisualizers.swift
 MuVis

 Abstract:
 A collection of Visualizer-Views (containing their name)
*/

import SwiftUI

struct Visualization {
    /// The visualization's name is shown as text in the titlebar
    var name: String
    /// A visualization's view is the View that renders it.
    var view: AnyView
    
    init(_ name: String, view: AnyView) {
        self.name = name
        self.view = view
    }
}

/// A collection of Visualizer-Views (containing their name)
let visList: [Visualization] =  [
    Visualization ("PianoKeyboard",           view: AnyView(PianoKeyboard() ) ),
    Visualization ("Spectrum",                view: AnyView(Spectrum() ) ),
    Visualization ("Music Spectrum",          view: AnyView(MusicSpectrum() ) ),
    Visualization ("MuSpectrum",              view: AnyView(MuSpectrum() ) ),
    Visualization ("Spectrum Bars",           view: AnyView(SpectrumBars() ) ),
    Visualization ("Overlapped Octaves",      view: AnyView(OverlappedOctaves() ) ),
    Visualization ("Octave-Aligned Spectrum", view: AnyView(OctaveAlignedSpectrum() ) ),
    Visualization ("Elliptical OAS",          view: AnyView(EllipticalOAS() ) ),
    Visualization ("Spiral OAS",              view: AnyView(SpiralOAS() ) ),
    Visualization ("Harmonic Alignment",      view: AnyView(HarmonicAlignment() ) ),
    Visualization ("Harmonic Spectrum",       view: AnyView(HarmonicSpectrum() ) ),
    Visualization ("TriOct Spectrum",         view: AnyView(TriOctSpectrum() ) ),
    Visualization ("Overlapped Harmonics",    view: AnyView(OverlappedHarmonics() ) ),
    Visualization ("Harmonograph",            view: AnyView(Harmonograph() ) ),
    Visualization ("Lissajous",               view: AnyView(Lissajous() ) ),
    Visualization ("Cymbal",                  view: AnyView(Cymbal() ) ),
    Visualization ("Lava Lamp",               view: AnyView(LavaLamp() ) ),
    Visualization ("Superposition",           view: AnyView(Superposition() ) ),
    Visualization ("Superposition2",          view: AnyView(Superposition2() ) ),
    Visualization ("Rainbow Spectrum",        view: AnyView(RainbowSpectrum() ) ),
    Visualization ("Waterfall",               view: AnyView(Waterfall() ) ),
    Visualization ("MuSpectrogram CG",        view: AnyView(MuSpectrogramCG() ) ),
    Visualization ("Peaks Spectrogram CG",    view: AnyView(PeaksSpectrogramCG() ) ),
    Visualization ("Peaks Spectrogram",       view: AnyView(PeaksSpectrogram() ) ),
    Visualization ("Rainbow OAS",             view: AnyView(RainbowOAS() ) ),
    Visualization ("Rainbow Ellipse",         view: AnyView(RainbowEllipse() ) ),
    Visualization ("Spinning Ellipse",        view: AnyView(SpinningEllipse() ) ),
    Visualization ("Rabbit Hole",             view: AnyView(RabbitHole() ) ),
    Visualization ("Audio Eclipse",           view: AnyView(AudioEclipseView())),
]
