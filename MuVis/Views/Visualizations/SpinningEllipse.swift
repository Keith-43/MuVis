/// SpinningEllipse.swift
/// MuVis
///
/// The SpinningEllipse visualization makes the RainbowEllipse more dynamic by making it spin.
/// Also, an angular offset is applied to each muSpectrum to make the inward drifting of the spectral history more interesting.
///
///  Advanced SwiftUI Animations – Part 5: Canvas
///  https://swiftui-lab.com/swiftui-animations-part5/
///
///         foreground
// option0  time-varying out-to-in color
// option1  hueGradient
// option2  fixed octaveColor
// option3  hueGradientX5
// option4  time-varying out-to-in color    slow
// option5  hueGradient                     slow
// option6  fixed octaveColor               very slow
// option7  hueGradientX5                   very slow
//
/// Created by Keith Bromley on 1 March 2021. (adapted from his previous java version (called Nautilus2) in the Polaris app)


import SwiftUI


struct SpinningEllipse: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme
    
    static var hueOld: [Double] = [Double](repeating: 0.0, count: 64)
    static var colorIndex: Int = 0
    
    var body: some View {
    
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        Canvas { context, size in

            let width: Double  = size.width
            let height: Double = size.height
            let X0: Double = 0.5 * width   // the origin of the ellipses
            let Y0: Double = 0.55 * height // the origin of the ellipses (Deliberately set below the halfway line)
            let A0: Double = width  / 2.0  // the horizontal radius of the largest ellipse
            let B0: Double = 0.45 * height // the vertical   radius of the largest ellipse (Constrained by the pane bottom)
            var B:  Double = 0.0           // used as the time-varying reduced B0 value
            
            var x: Double = 0.0       // The drawing origin is in the upper left corner.
            var y: Double = 0.0       // The drawing origin is in the upper left corner.
            var startX: Double = 0.0
            var startY: Double = 0.0
            var endX: Double = 0.0
            var endY: Double = 0.0
            
            var theta:  Double = 0.0    // The angle theta starts at the 12 o'clock position and proceeds clockwise.
            var startOctTheta: Double = 0.0     // angle at start of octave
            var endOctTheta: Double = 0.0       // angle at end of octave
            var mag: Double = 0.0        // used as a preliminary part of the audio amplitude value
            
            let octaveCount: Int = 6  // The FFT provides 7 octaves (plus 5 unrendered notes)
            let octaveFraction: Double = 1.0 / Double(octaveCount)      // octaveFraction = 1/6 = 0.1666666
            let pointFraction:  Double = octaveFraction / Double(pointsPerOctave)  // pointFraction = 1/(6*144)
            
            // ellipseCount is the number of ellipses rendered to show the history of each spectrum
            let ellipseCount: Int = 48              // ellipseCount must be <= historyCount
            let newestHist: Int = historyCount - 1  // The newest line of data is at the end of the muSpecHistory array.
                
            var angleOffset: Double = 0.0           // angleOffset controls the rotation of the spiral
            let angleInc: Double = 0.01
    
            let now = Date()
            let time = now.timeIntervalSinceReferenceDate
            let frequency: Double = 0.05  // 1 cycle per 20 seconds
            let offset: Double = cos(2.0 * Double.pi * frequency * time ) // oscillates between -1 and +1
            
            let colorSize: Int = 96    // This determines the frequency of the color change over time.
            SpinningEllipse.colorIndex = (SpinningEllipse.colorIndex >= colorSize) ?
                                        0 :
                                        SpinningEllipse.colorIndex + 1
            let startHue360: Int = Int( 360.0 * Double(SpinningEllipse.colorIndex) / Double(colorSize) )
            
            // Use local short name to improve code readablity:
            let option = settings.option
            let muSpecHistory = manager.muSpecHistory
            
            manager.skipHist =  ( option==6 || option==7 ) ? 2 :
                                ( option==4 || option==5 ) ? 1 : 0
            
// ---------------------------------------------------------------------------------------------------------------------
            // First render the ellipseCount ellipses - each with its own old spectrum:
            // Render octave 0 of the spectrum between the 12 o'clock and  2 o'clock ellipse positions:
            // Render octave 1 of the spectrum between the  2 o'clock and  4 o'clock ellipse positions:
            // Render octave 2 of the spectrum between the  4 o'clock and  6 o'clock ellipse positions:
            // Render octave 3 of the spectrum between the  6 o'clock and  8 o'clock ellipse positions:
            // Render octave 4 of the spectrum between the  8 o'clock and 10 o'clock ellipse positions:
            // Render octave 5 of the spectrum between the 10 o'clock and 12 o'clock ellipse positions:
            // The radius of each ellipse goes from halfHeight to zero:
                
            for ellipseNum in 0 ..< ellipseCount {       //  0 <= ellipseNum < 48
            
                let ellipseOffset: Int = (newestHist - ellipseNum) * sixOctPointCount  // ellipseNum = 0 is the newest spectrum
                // let ellipseOffset: Int = ellipseNum * sixOctPointCount  // ellipseNum = 0 is the oldest spectrum
                
                //  It is easier to visualize the graphics using ellipseNum & ellipseCount instead of hist & historyCount
                let histOffset = ellipseOffset

                // As ellipseNum goes from 0 to ellipseCount, ellipseRampUp goes from 1/32 to 1.0:
                let ellipseRampUp: Double = Double(ellipseNum+1) / Double(ellipseCount)

                // As ellipseNum goes from 0 to ellipseCount, ellipseRampDown goes from 1.0 to 1/32:
                let ellipseRampDown: Double = Double(ellipseCount - ellipseNum) / Double(ellipseCount)

                angleOffset += angleInc    // Each frame, the angleOffset starts at 0
                let startEllipseTheta = ellipseRampUp * angleOffset
                B = B0 * offset

                let hue: Double = (ellipseNum == ellipseCount-1) ?                  // time-varying out-to-in color
                                  Double(startHue360) / 360.0 :
                                  RainbowEllipse.hueOld[ellipseNum+1]               // 0.0 <= hue < 1.0
                
                for oct in 0 ..< octaveCount {     //  0 <= oct < 6
                    
                    startOctTheta = ellipseRampUp * angleOffset + ( Double(oct) * octaveFraction )
                    startX = X0 + ellipseRampDown * A0 * Double( sin(2.0 * Double.pi * startOctTheta ) )
                    startY = Y0 - ellipseRampDown * B  * Double( cos(2.0 * Double.pi * startOctTheta ) )
                    
                    endOctTheta = ellipseRampUp * angleOffset + ( Double(oct+1) * octaveFraction )
                    endX = X0 + ellipseRampDown * A0 * Double( sin(2.0 * Double.pi * endOctTheta ) )
                    endY = Y0 - ellipseRampDown * B  * Double( cos(2.0 * Double.pi * endOctTheta ) )
                    
                    var path = Path()
                    
                    if(oct==0) {            // oct=0  theta=0  point=0
                        // Calculate the x,y cordinates at the start of each ellipse:
                        let startEllipseX = X0 + ellipseRampDown * A0 * Double( sin(2.0 * Double.pi * startEllipseTheta ) )
                        mag = 0.2 * Double(muSpecHistory[histOffset])
                        let startEllipseY = Y0 - ellipseRampDown * B  * Double( cos(2.0 * Double.pi * startEllipseTheta ) )
                                               - (mag * Y0 * ellipseRampDown)
                        path.move( to: CGPoint(x: startEllipseX, y: startEllipseY) )
                    }else {
                        path.move( to: CGPoint(x: x, y: y) )    // continue on from last point in previous octave
                    }
                    
                    // Now ensure that we read the correct spectral data from the muSpecHistory[] array:
                    let octaveOffset: Int = oct * pointsPerOctave
                    
                    for point in 0 ..< pointsPerOctave {    // 12 * 12 = 144 = number of points per octave

                        theta = startOctTheta + ( Double(point) * pointFraction )  // 0 <= theta < 1
                        x = X0 + ellipseRampDown * A0 * Double( sin(2.0 * Double.pi * theta) )
                        
                        let tempIndex = histOffset + octaveOffset + point
                        mag = 0.2 * Double(muSpecHistory[tempIndex])
                        mag = min(max(0.0, mag), 1.0)   // Limit over- and under-saturation.
                        y = Y0 - ellipseRampDown * B * Double( cos(2.0 * Double.pi * theta )) - (mag * Y0 * ellipseRampDown)
                        path.addLine(to: CGPoint(x: x,  y: y ) )
                    }
                    
                    if( option==0 || option==4 ) {
                    context.stroke( path,                                               // time-varying out-to-in color
                                    with: .color(Color(hue: hue, saturation: 1.0, brightness: 1.0)),
                                    lineWidth:  0.3 + (ellipseRampDown * 3.0) )
                    
                    } else if( option==1 || option==5 ) {
                        context.stroke( path,                                           // hueGradient
                                        with: .linearGradient( hueGradient,
                                                               startPoint: CGPoint(x: startX, y: startY),
                                                               endPoint: CGPoint(x: endX, y: endY)),
                                        lineWidth: 0.3 + ellipseRampDown * 3.0 )
                
                    } else if( option==2 || option==6 ) {
                        let hue: Double = Double(oct) * octaveFraction
                        context.stroke( path,                                           // fixed octaveColor
                                        with: .color(Color(hue: hue, saturation: 1.0, brightness: 1.0)),
                                        lineWidth:  0.3 + (ellipseRampDown * 3.0) )

                    } else if( option==3 || option==7 ) {
                        context.stroke( path,                                           // hueGradientX5
                                        with: .linearGradient( hueGradientX5,
                                                               startPoint: CGPoint(x: startX, y: startY),
                                                               endPoint: CGPoint(x: endX, y: endY)),
                                        lineWidth: 0.3 + ellipseRampDown * 3.0 )
                    }
                    
                } // end of for() loop over oct
                
                RainbowEllipse.hueOld[ellipseNum] = hue
                
            }  // end of for() loop over ellipseNum

        }  // end of Canvas{}
        .background(backgroundColor)  // Toggle between black and white background color.
        
    }  // end of var body: some View
}  // end of SpinningEllipse struct

#Preview("SpinningEllipse") {
    SpinningEllipse()
        .enhancedPreview()
}
