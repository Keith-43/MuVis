/*
 MuVisApp.swift
 MuVis
 
 Created by Keith Bromley on 28 Feb 2023.

 Abstract:
 The MuVis app runs on Apple's macOS, iOS, and iPadOS. It was developed using Swift, SwiftUI, and Xcode.
 It consists of three main parts: the audio-capture engine, the user interface, and the several visualizations.
 
 The AudioManager class (1) captures realtime audio samples from the user-designated audio source, (2) applies an FFT computation, and publishes the resulting spectrum to the visualization Views.  It does this 60 times per second, and provides the "heartbeat" for the app.
 The ContentView struct handles the app's user interface.  It is based on Apple's SwiftUI.  See the UserGuide document for user instructions.
 The app currently has twenty-nine visualization Views.  Some are scientifically based, some are music-theory based, and some are simply aesthetically pleasing.
*/

import SwiftUI

// Declare and intialize global constants and variables:
var showMSPF: Bool = true       // display the Performance Monitor's "milliseconds per frame"

var usingBlackHole: Bool = false // true if using BlackHole as sole audio input (macOS only)
// To use BlackHole audio driver: SystemSettings | Sound, set Input to BlackHole 2ch; set Ouput to Multi-Output Device.
// To use micOn: SystemSettings | Sound, Input: MacBook Pro Microphone; Ouput: Multi-Output Device

let notesPerOctave   = 12       // An octave contains 12 musical notes.
let pointsPerNote    = 12       // The number of frequency samples within one musical note.
let pointsPerOctave  = notesPerOctave * pointsPerNote  // 12 * 12 = 144

let eightOctNoteCount   = 96    // from C1 to B8 is 96 notes  (  0 <= note < 96 ) (This covers 8 octaves.)
let eightOctPointCount  = eightOctNoteCount * pointsPerNote  // 96 * 12 = 1,152  // number of points in 8 octaves

let sixOctNoteCount  = 72       // the number of notes within six octaves
let sixOctPointCount = sixOctNoteCount * pointsPerNote  // 72 * 12 = 864   // number of points within six octaves

let historyCount    = 48        // Keep the 48 most-recent values of muSpectrum[point] in a circular buffer
let peakCount       = 16        // We only consider the loudest 16 spectral peaks.
let peaksHistCount  = 100       // Keep the 100 most-recent values of peakBinNumbers in a circular buffer

// Create a 96-element array of accidental notes to render the keyboard (denoting white and black keys) in the background:
//                              C      C#    D      D#    E      F      F#    G      G#    A      A#    B
let accidentalNotes: [Bool] = [ false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false,
                                false, true, false, true, false, false, true, false, true, false, true, false ]

// MARK: - Main

@main
struct MuVisApp: App {
    @Bindable var manager = AudioManager()
    @Bindable var settings = Settings()
    
    var body: some Scene {
        WindowGroup {
            ContentView(manager: manager, settings: settings)
                .environment(manager)
                .environment(settings)
                .frame( minWidth:  400.0, idealWidth: 1000.0, maxWidth:  .infinity,
                        minHeight: 300.0, idealHeight: 800.0, maxHeight: .infinity, alignment: .center)
        }
    }
}
