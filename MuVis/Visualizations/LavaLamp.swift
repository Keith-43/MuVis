///  LavaLamp.swift
///  MuVis
///
///  The initial inspiration for this LavaLamp visualization came from Alex Dremov's "MorphingShapes" Swift package at
///  https://github.com/AlexRoar/MorphingShapes
///  as described in his article at
///  https://alexdremov.me/swiftui-advanced-animation/
///
///  I tried to adapt his code to my needs, but I had great difficulty in understanding it, so I decided to start from scratch.
///
///  Shape:
///  https://developer.apple.com/documentation/swiftui/shape
///  https://swiftontap.com/shape
///
///  Animation Repeat, Delay, and Speed
///  https://designcode.io/swiftui-handbook-horizontal-animation-repeat-delay-and-speed
///
///  Positioning for SwiftUI views
///  https://www.hackingwithswift.com/books/ios-swiftui/absolute-positioning-for-swiftui-views
///
///  https://www.hackingwithswift.com/quick-start/swiftui/how-to-fix-cannot-assign-to-property-self-is-immutable
///  https://stackoverflow.com/questions/61225841/environmentobject-not-found-for-child-shape-in-swiftui
///  https://www.hackingwithswift.com/forums/swiftui/environmentobject-usage-in-init-of-a-view/5795
///
///  Introduction to Animations With SwiftUI (Marin Todorov)
///  https://www.raywenderlich.com/books/ios-animations-by-tutorials/v7.0/chapters/1-introduction-to-animations-with-swiftui
///  https://github.com/raywenderlich/iat-materials/tree/editions/7.0
///
///  Multiple Animations in SwiftUI
///  https://medium.com/devtechie/multiple-animations-in-swiftui-df4cee579f
///
///  SwiftUI animation sequence (Christhian Leon)
///  https://medium.com/nerd-for-tech/swiftui-animation-sequence-7a0cf364773a
///  https://github.com/cristhianleonli/AnimationSequence
///
///  Swift UI .animation - avoid affecting all animatable values
///  https://stackoverflow.com/questions/64125238/swift-ui-animation-avoid-affecting-all-animatable-values
///  https://stackoverflow.com/questions/62630729/swiftui-animating-multiple-parameters-with-different-curves
///  https://stackoverflow.com/questions/69131171/how-to-animate-shape-with-values-from-nested-struct-in-swiftui
///  https://www.hackingwithswift.com/quick-start/swiftui/how-to-run-some-code-when-state-changes-using-onchange
///
///   Shape modifiers: .trim(), .size(), .scale(), .rotation(), .offset(), .stroke(), .fill()
///   View modifiers: .frame(), .offset(), .position(), .scaleEffect(), .rotationEffect()
///
///   Ellipse().position()   sets the center point of the ellipse
///   Ellipse().frame()   sets the width & height of the ellipse about it's center point.
///
///   hue = 0.00 is red;  0.17 is yellow;  0.33 is green;  0.50 is cyan;  0.66 is blue;  0.83 is magenta;  1.00 is red
///   In light mode, have hue go from 0.17 (yellow) to 1.00 (red)
///   In dark mode, have hue go from 0.66 (blue) to 0.00 (red)
///
//          background          foreground
// option0  time-varying hue    all ellipses
// option1  time-varying hue    no small
// option2  time-varying hue    no medium
// option3  time-varying hue    no big
// option4  white/black         all ellipses
// option5  white/black         no small
// option6  white/black         no medium
// option7  white/black         no big
///
///  Created by Keith Bromley in Aug 2022.


import SwiftUI
import Combine

struct LavaLamp: View {
    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    
    static let ellipseCount: Int = 10
    
    @State private var animateF: Bool = false    // used to trigger animation every 100 clock cycles    Fast
    @State private var animateM: Bool = false    // used to trigger animation every 200 clock cycles    Medium
    @State private var animateS: Bool = false    // used to trigger animation every 300 clock cycles    Slow
    
    // Each ellipse has 3 animatable properties: diamX, posX, and posY.
    // Each boolean variable biggerX, moveX, and moveY state whether that property is currently changing for that ellipse.
    @State private var biggerX: [Bool] = [Bool](repeating: false, count: ellipseCount) // controls whether diamX increases or decreases
    @State private var moveX:   [Bool] = [Bool](repeating: false, count: ellipseCount) // controls whether ellipse moves right or left
    @State private var moveY:   [Bool] = [Bool](repeating: false, count: ellipseCount) // controls whether ellipse moves up or down
    @State private var hue:   [Double] = [Double](repeating: 0.0, count: ellipseCount) // controls the color of each ellipse
    @State private var octEnergy: [Double] = [Double](repeating: 0.0, count: 6)
    
    // Keep track of the horizontal and vertical diameter of each ellipse:
    // The starting horizontal diameter of each ellipse is:
    @State private var diamX: [CGFloat] = [0.3,  0.3,  0.3,  0.2,  0.2,  0.2,  0.1,  0.1,  0.1,  0.1]
    // The starting vertical diameter of each ellipse is:
    @State private var diamY: [CGFloat] = [0.3,  0.3,  0.3,  0.2,  0.2,  0.2,  0.1,  0.1,  0.1,  0.1]
    
    // Keep track of the horizontal and vertical position of each ellipse:
    // The starting horizontal position of each ellipse is:
    @State private var posX: [CGFloat] = [0.15, 0.50, 0.85, 0.90, 0.10, 0.27, 0.36, 0.45, 0.63, 0.72]
    // The starting vertical position of each ellipse is:
    @State private var posY: [CGFloat] = [0.15, 0.15, 0.15, 0.10, 0.10, 0.10, 0.05, 0.05, 0.05, 0.05]
    
    @State private var incrementX: CGFloat = 0.0    // horizontal position increment
    @State private var count: Int64 = 0
    @State private var bckgrndHue360: Int = 0       // 0 <= hue < 360       // hue color of the pane background
    
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    init() {
        // Publishes a clock tick every tenth of a second:
        timer = Timer.publish(every: 0.1, on: .current, in: .common).autoconnect()
    }
    
    var body: some View {
        
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        let option = settings.option
        // let _ = print("\(octEnergy[0]), \(octEnergy[1]), \(octEnergy[2]), \(octEnergy[3]), \(octEnergy[4]), \(octEnergy[5])")
        
        GeometryReader { geometry in
            let width:  CGFloat = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            
            ZStack(){
                if(option != 3 && option != 7) {
                    ForEach(0 ... 2, id: \.self) { i in // Ellipses 0,1,2 are big and slow.
                        Ellipse()
                            .frame(width:  biggerX[i] ? diamX[i] * 1.2 * width  : diamX[i] * 0.8 * width,
                                   height: diamY[i] * height )
                            .position( x: posX[i] * width,
                                       y: moveY[i] ? 0.5*diamY[i] * height : (1.0 - 0.5*diamY[i]) * height )
                            .animation(.easeInOut(duration: 29.9), value: animateS)
                            .foregroundColor(Color(hue: hue[i],
                                                   saturation: 1.0,
                                                   brightness: octEnergy[i] ) )
                    }
                }

                if(option != 2 && option != 6) {
                    ForEach(3 ... 5, id: \.self) { i in // Ellipses 3,4,5 are medium-size and medium-speed.
                        Ellipse()
                            .frame(width:  biggerX[i] ? diamX[i] * 1.2 * width  : diamX[i] * 0.8 * width,
                                   height: diamY[i] * height )
                            .position( x: posX[i] * width,
                                       y: moveY[i] ? 0.5 * diamY[i] * height : (1.0 - 0.5*diamY[i]) * height )
                            .animation(.easeInOut(duration: 19.9), value: animateM)
                            .foregroundColor(Color(hue: hue[i],
                                                   saturation: 1.0,
                                                   brightness: octEnergy[i] ) )
                    }
                }
                
                if(option != 1 && option != 5) {
                    ForEach(6 ... 9, id: \.self) { i in // Ellipses 6,7,8,9 are small and fast.
                        Ellipse()
                            .frame(width:  biggerX[i] ? diamX[i] * 1.2 * width  : diamX[i] * 0.8 * width,
                                   height: diamY[i] * height )
                            .position( x: posX[i] * width,
                                       y: moveY[i] ? 0.5 * diamY[i] * height : (1.0 - 0.5*diamY[i]) * height )
                            .animation(.easeInOut(duration: 9.9), value: animateF)
                            .foregroundColor(Color(hue: hue[i],
                                                   saturation: 1.0,
                                                   brightness: octEnergy[5] ) )
                    }
                }
            }
            .onReceive(timer, perform: { _ in
                updateParameters()
            })
            .background( option > 3 ?
                         backgroundColor :
                         Color( hue: Double(bckgrndHue360)/360.0,
                                saturation: 1.0,
                                brightness: colorScheme == .dark ?  0.5 : 1.0 ))

        } // end of GeometryReader

    } // end of var body: some View



    func updateParameters() {
        count += 1
        bckgrndHue360 = (bckgrndHue360 + 1) % 360   // hue cycles from 0.0 (red) to 1.0 (red) in 36 seconds

        for i in 0 ..< LavaLamp.ellipseCount {
            hue[i] = Double( (bckgrndHue360 + (i-4) * 4) % 360 ) / 360.0  // i-4 = -4, -3, -2, -1, 0, +1, +2, +3, +4
        }

        // Sum the amplitudes of the peaks that occur in each octave:
        for oct in 0 ..< 6 {
            octEnergy[oct] = 0.0
            for peakNum in 0 ..< peakCount {                                                // peakCount = 16
                if (manager.peakBinNumbers[peakNum] >= noteProc.octBottomBin[oct] &&
                    manager.peakBinNumbers[peakNum] <= noteProc.octTopBin[oct]) {
                    octEnergy[oct] += 0.2 * manager.peakAmps[peakNum]
                }
            }
            octEnergy[oct] = min(max(0.2, octEnergy[oct]), 1.0)  // octEnergy will allways be > 0.2
        }

        /*
        print( String(format: "%.3f ", octEnergy[0]),
               String(format: "%.3f ", octEnergy[1]),
               String(format: "%.3f ", octEnergy[2]),
               String(format: "%.3f ", octEnergy[3]),
               String(format: "%.3f ", octEnergy[4]),
               String(format: "%.3f ", octEnergy[5]) )
        */

        // First, update parameters for the three big, slow ellipses:
        if count%200 == 1 {
            animateS.toggle()  // The variable "animateS" toggles once every 20 seconds
            for i in 0 ... 2 {
                if(Int.random(in:0...1)==0) { biggerX[i].toggle() }
                if(Int.random(in:0...3)==0) { moveX[i].toggle()   } // make horizontal movement less frequent
                if(Int.random(in:0...2)==0) { moveY[i].toggle()   }
            }

            for i in 0 ... 2 {
                incrementX = moveX[i] ? 0.1 : -0.1
                if( posX[i] <= 0.05 + 0.5*diamX[i] ) {incrementX =  0.1}
                if( posX[i] >= 0.95 - 0.5*diamX[i] ) {incrementX = -0.1}
                posX[i] = posX[i] + incrementX
            }
        }


        // Second, update parameters for the three medium ellipses:
        if count%150 == 1 {
            animateM.toggle()  // The variable "animateM" toggles once every 15 seconds
            for i in 3 ... 5 {
                if(Int.random(in:0...1)==0) { biggerX[i].toggle() }
                if(Int.random(in:0...3)==0) { moveX[i].toggle()   } // make horizontal movement less frequent
                if(Int.random(in:0...2)==0) { moveY[i].toggle()   }
            }

            for i in 3 ... 5 {
                incrementX = moveX[i] ? 0.1 : -0.1
                if( posX[i] <= (0.05 + 0.5*diamX[i]) ) {incrementX =  0.1}
                if( posX[i] >= (0.95 - 0.5*diamX[i]) ) {incrementX = -0.1}
                posX[i] = posX[i] + incrementX
            }
        }


        // Third, update parameters for the four small ellipses:
        if count%100 == 1 {
            animateF.toggle()  // The variable "animateF" toggles once every 10 seconds
            for i in 6 ... 9 {
                if(Int.random(in:0...1)==0) { biggerX[i].toggle() }
                if(Int.random(in:0...3)==0) { moveX[i].toggle()   } // make horizontal movement less frequent
                if(Int.random(in:0...2)==0) { moveY[i].toggle()   }
            }

            for i in 6 ... 9 {
                incrementX = moveX[i] ? 0.1 : -0.1
                if( posX[i] <= (0.05 + 0.5*diamX[i]) ) {incrementX =  0.1}
                if( posX[i] >= (0.95 - 0.5*diamX[i]) ) {incrementX = -0.1}
                posX[i] = posX[i] + incrementX
            }
        }

    } // end of updateParameters() func

} // end of LavaLamp struct
