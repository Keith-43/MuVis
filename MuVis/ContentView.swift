//  ContentView.swift
//  MuVis
//
//  Apple's declarative unified Toolbar API:
//  https://swiftwithmajid.com/2020/07/15/mastering-toolbars-in-swiftui/
//  https://swiftwithmajid.com/2022/09/07/customizing-toolbars-in-swiftui/
//  https://developer.apple.com/documentation/swiftui/toolbars/
//
//  Swipe gesture:
//  https://stackoverflow.com/questions/60885532/how-to-detect-swiping-up-down-left-and-right-with-swiftui-on-a-view
//
//  Created by Keith Bromley on 2/28/23.


import SwiftUI
import AudioVisualizer
import QuickLook

struct ContentView: View {
    @Bindable var manager: AudioManager
    @Bindable var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var visNum: Int = 0      // visualization number - used as an index into the visList array
    @State private var enableSongFileSelection: Bool = false
    @State private var pauseButtonIsPaused: Bool = false
    @State private var previousAudioURL: URL = URL(string: "https://www.apple.com")!

    @State private var userGuideUrl: URL?
    @State private var visualizationsGuideUrl: URL?

    @State private var showTopToolbar: Bool = true
    @State private var showBottomToolbar: Bool = true
    
    struct Visualization {
        var name: String        // The visualization's name is shown as text in the titlebar
        var view: AnyView       // A visualization's view is the View that renders it.
        
        init(_ name: String, view: AnyView) {
            self.name = name
            self.view = view
        }
    }

    // Create a list of our 24 visualizations (containing their name and their corresponding View():
    let visList: [Visualization] =  [
        Visualization ("PianoKeyboard",               view: AnyView(PianoKeyboard() ) ),
        Visualization ("Spectrum",                    view: AnyView(Spectrum() ) ),
        Visualization ("Music Spectrum",              view: AnyView(MusicSpectrum() ) ),
        Visualization ("MuSpectrum",                  view: AnyView(MuSpectrum() ) ),
        Visualization ("Spectrum Bars",               view: AnyView(SpectrumBars() ) ),
        Visualization ("Overlapped Octaves",          view: AnyView(OverlappedOctaves() ) ),
        Visualization ("Octave-Aligned Spectrum",     view: AnyView(OctaveAlignedSpectrum() ) ),
        Visualization ("Elliptical OAS",              view: AnyView(EllipticalOAS() ) ),
        Visualization ("Spiral OAS",                  view: AnyView(SpiralOAS() ) ),
        Visualization ("Harmonic Alignment",          view: AnyView(HarmonicAlignment() ) ),
        Visualization ("Harmonic Spectrum",           view: AnyView(HarmonicSpectrum() ) ),
        Visualization ("TriOct Spectrum",             view: AnyView(TriOctSpectrum() ) ),
        Visualization ("Overlapped Harmonics",        view: AnyView(OverlappedHarmonics() ) ),
        Visualization ("Harmonograph",                view: AnyView(Harmonograph() ) ),
        Visualization ("Lissajous",                   view: AnyView(Lissajous() ) ),
        Visualization ("Cymbal",                      view: AnyView(Cymbal() ) ),
        Visualization ("Lava Lamp",                   view: AnyView(LavaLamp() ) ),
        Visualization ("Superposition",               view: AnyView(Superposition() ) ),
        Visualization ("Rainbow Spectrum",            view: AnyView(RainbowSpectrum() ) ),
        Visualization ("Waterfall",                   view: AnyView(Waterfall() ) ),
        Visualization ("MuSpectrogram CG",            view: AnyView(MuSpectrogramCG() ) ),
        Visualization ("Peaks Spectrogram CG",        view: AnyView(PeaksSpectrogramCG() ) ),
        Visualization ("Peaks Spectrogram",           view: AnyView(PeaksSpectrogram() ) ),
        Visualization ("Rainbow OAS",                 view: AnyView(RainbowOAS() ) ),
        Visualization ("Rainbow Ellipse",             view: AnyView(RainbowEllipse() ) ),
        Visualization ("Spinning Ellipse",            view: AnyView(SpinningEllipse() ) ),
        Visualization ("Rabbit Hole",                 view: AnyView(RabbitHole() ) ),
        Visualization ("Audio Eclipse",               view: AnyView(AudioEclipseView())),
    ]

    var body: some View {

        VStack(spacing: 0) {

//----------------------------------------------------------------------------------------------------------------------
            if(showTopToolbar) {
                // The following HStack constitutes the Top Toolbar:
                HStack {

                    Text("Gain-")
                        .padding(.leading)

                    Slider(value: $manager.userGain, in: 0.0 ... 8.0)  //  0.0 <= userGain <= 8.0
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.red, lineWidth: 2)
                        )
                        .onChange(of: manager.userGain) { _, value in
                            manager.userGain = Float(value)
                        }
                        .help("This slider controls the gain of the visualization.")

                    if( showMSPF==true ) { Text("MSPF: \( lround(manager.averageTime) )") }
                    
                    Slider(value: $manager.userSlope, in: 0.0 ... 0.4)      // 0 <= userSlope <= 0.4
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.red, lineWidth: 2)
                        )
                        .onChange(of: manager.userSlope) { _, value in
                            manager.userSlope = Float(value)
                        }
                        .help("This slider controls the frequency slope of the visualization.")

                    Text("-Treble")
                        .padding(.trailing)

                }  // end of HStack{}
            }

//----------------------------------------------------------------------------------------------------------------------
             // The following View constitutes the main visualization rendering pane:
            visList[visNum].view
                // .drawingGroup()     // improves graphics performance by utilizing off-screen buffers
                .navigationTitle("MuVis - Music Visualizer    -    \(visList[visNum].name)")
                .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                    .onEnded { value in
                        switch(value.translation.width, value.translation.height) {
                        case ( ...0, -30...30 ):                                                         // left swipe
                            visNum += 1
                            if( visNum >= visList.count ) { visNum = 0 }
                        case ( 0..., -30...30 ):                                                         // right swipe
                            visNum -= 1
                            if( visNum <= -1 ) { visNum=visList.count-1 }
                        case ( -100...100, ...0 ):                                                        // up swipe
                            settings.option += 1
                            if( settings.option >= settings.optionCount ) { settings.option = 0 }
                        case ( -100...100, 0... ):                                                        // down swipe
                            settings.option -= 1
                            if( settings.option <= -1 ) { settings.option = settings.optionCount-1 }
                        default:  print("Drag gesture not detected properly.")
                        }
                    }
                )

                .gesture(TapGesture(count: 3)
                    .onEnded({
                        #if os(iOS)
                            showTopToolbar.toggle()         // iOS only: 3 clicks toggles showing toolbars
                            showBottomToolbar.toggle()
                        #endif
                        #if os(macOS)
                            usingBlackHole.toggle()         // macOS only: 3 clicks toggles usingBlackHole
                            manager.stopMusicPlay()
                            manager.processAudio()
                        #endif
                    }
                // To use BlackHole audio driver: SystemSettings | Sound, Input: BlackHole 2ch; Ouput: Multi-Output Device
                // To use micOn: SystemSettings | Sound, Input: MacBook Pro Microphone; Ouput: Multi-Output Device
                ) )

            
//----------------------------------------------------------------------------------------------------------------------
            if(showBottomToolbar) {
                // The following HStack constitutes the Bottom Toolbar:
                HStack {

                    Group {
                        Button(action: {                    // "Previous Visualization" button
                            // visNum -= 1
                            // if(visNum <= -1) {visNum = visList.count - 1}
                            visNum = (visNum <= 0) ? visList.count - 1 : visNum - 1
                            manager.onlyPeaks = false       // Changing the visNum turns off the onlyPeaks variation.
                            settings.option = 0             // Changing the visNum resets the option to option=0.
                        } ) {
                            Image(systemName: "chevron.left")
                        }
                        .keyboardShortcut(KeyEquivalent.leftArrow, modifiers: [])
                        .help("This button retreats to the previous visualization.")
                        .disabled(pauseButtonIsPaused)      // gray-out "Previous Vis" button if pauseButtonIsPaused is true
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                                .tint(.pink)
                        )
                        .padding(.leading)

                        Text("Vis:\(visNum)").font(.callout)

                        Button( action: {                   // "Next Visualization" button
                            // visNum += 1
                            // if(visNum >= visList.count) {visNum = 0}
                            visNum = (visNum >= visList.count-1) ? 0 : visNum + 1
                            manager.onlyPeaks = false       // Changing the visNum turns off the onlyPeaks variation.
                            settings.option = 0             // Changing the visNum resets the option to option=0.
                        } ) {
                            Image(systemName: "chevron.right")
                        }
                        .keyboardShortcut(KeyEquivalent.rightArrow, modifiers: [])
                        .help("This button advances to the next visualization.")
                        .disabled(pauseButtonIsPaused)      // gray-out "Next Vis" button if pauseButtonIsPaused is true
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                        )
                    }

                    Spacer()

                    Group {
                        Button(action: {                    // "Previous Option" button
                            settings.option -= 1
                            if( settings.option <= -1 ) { settings.option = settings.optionCount - 1 }
                        } ) {
                            Image(systemName: "chevron.down")
                        }
                        .keyboardShortcut(KeyEquivalent.downArrow, modifiers: [])   // downArrow key decrements the option
                        .help("This button retreats to the previous option.")
                        .disabled(pauseButtonIsPaused)  // gray-out PreviousOption button if pauseButtonIsPaused is true
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                                .tint(.pink)
                        )
                        .padding(.leading)
                        
                        Text("Option:\(settings.option)").font(.callout)
                        
                        Button( action: {                   // "Next Option" button
                            settings.option += 1
                            if( settings.option >= settings.optionCount ) { settings.option = 0 }
                        } ) {
                            Image(systemName: "chevron.up")
                        }
                        .keyboardShortcut(KeyEquivalent.upArrow, modifiers: []) // upArrow key increments the option
                        .help("This button advances to the next option.")
                        .disabled(pauseButtonIsPaused)      // gray-out NextOption button if pauseButtonIsPaused is true
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                        )
                    }
                    
                    Spacer()
                    
                    Group {
                        Button(action: {                                        // "Pause / Resume" button
                            if( manager.isPaused ) { manager.startMusicPlay() } // User clicked on "Resume"
                            else { manager.pauseMusicPlay() }                   // User clicked on "Pause"
                            manager.isPaused.toggle()
                            pauseButtonIsPaused.toggle()
                        } ) {
                            if(pauseButtonIsPaused) {Image(systemName:"play.fill")}else{Image(systemName:"pause.fill")}
                        }
                        .help("This button pauses or resumes the audio.")
                        .disabled(manager.micOn)            // gray-out Pause/Resume button if micOn is true
                        .disabled(usingBlackHole)           // gray-out Pause/Resume button when using BlackHole
                        .padding(.trailing)
                        
                        if(!usingBlackHole) {
                            
                            Button( action: {                                   // "Microphone On/Off" button
                                manager.micOn.toggle()      // This is the only place in MuVis that micOn changes.
                                manager.stopMusicPlay()
                                manager.processAudio()
                            } ) {
                                if(manager.micOn) {Image(systemName:"mic.slash.fill")}else{Image(systemName:"mic.fill")}
                            }
                            .help("This button turns the microphone on and off.")
                            .disabled(pauseButtonIsPaused)   // gray-out MicOn/Off button if pauseButtonIsPaused is true
                            .padding(.trailing)
                            
                            Button( action: {                                   // "Select Song" button
                                previousAudioURL.stopAccessingSecurityScopedResource()
                                if(!manager.micOn) {enableSongFileSelection = true} } ) {
                                    Image( systemName: "music.note.list" )
                                }
                                .help("This button opens a pop-up pane to select a song file.")
                                .disabled(manager.micOn)        // gray-out "Select Song" button if mic is enabled
                                .disabled(pauseButtonIsPaused) // gray-out SelectSong button if pauseButtonIsPaused is true
                                .fileImporter(
                                    isPresented: $enableSongFileSelection,
                                    allowedContentTypes: [.audio],
                                    allowsMultipleSelection: false
                                ) { result in
                                    if case .success = result {
                                        do {
                                            let audioURL: URL = try result.get().first!
                                            previousAudioURL = audioURL
                                            if audioURL.startAccessingSecurityScopedResource() {
                                                manager.filePath = audioURL.path
                                                if(!manager.micOn) {
                                                    manager.stopMusicPlay()
                                                    manager.processAudio()
                                                }
                                            }
                                        } catch {
                                            let nsError = error as NSError
                                            fatalError("File Import Error \(nsError), \(nsError.userInfo)")
                                        }
                                    } else {
                                        print("File Import Failed")
                                    }
                                }
                                .padding(.trailing)
                        }  // end of !usingBlackHole
                        
                        Button(action: { manager.onlyPeaks.toggle() } ) {       // "only Peaks / Normal" button
                            // Text( (manager.onlyPeaks == true) ? "Normal" : "Peaks").font(.footnote)
                            if(manager.onlyPeaks) {
                                   Image(systemName: "waveform.path" )
                            }else{ Image(systemName: "waveform.path.badge.minus" ) }
                        }
                        .help("This button enhances the peaks by subtracting the background spectrum.")
                        .disabled(pauseButtonIsPaused)  // gray-out "Peaks/Normal" button if pauseButtonIsPaused is true
                        .padding(.trailing)
                    }

                    Spacer()

                    Group {
                        Button(action: {                                        // "Display User Guide" button
                            userGuideUrl = Bundle.main.url( forResource: "UserGuide",
                                                            withExtension: "pdf" )
                        } ) {
                            Text("UserG").font(.callout)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                        )
                        .help("This button displays the User Guide.")
                        .quickLookPreview($userGuideUrl)
                        // https://developer.apple.com/documentation/swiftui/view/quicklookpreview(_:)?language=objc_9
                        // https://stackoverflow.com/questions/70341461/how-to-use-quicklookpreview-modifier-in-swiftui
                        .padding(.trailing)

                        Button(action: {                                        // "Display Visualizations Guide" button
                            visualizationsGuideUrl = Bundle.main.url( forResource: "Visualizations",
                                                                      withExtension: "pdf" )
                        } ) {
                            Text("VisG").font(.callout)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .strokeBorder(.blue, lineWidth: 2)
                        )
                        .help("This button displays the Visualizations Guide.")
                        .quickLookPreview($visualizationsGuideUrl)
                        .padding(.trailing)
                    }
                    
                }  // end of HStack
            }  // end of if(showBottomToolbar)
        }  // end of VStack
    }  // end of var body: some View
}
