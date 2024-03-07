/// RabbitHole.swift
/// MuVis
///
/// This RabbitHole visualization renders the time-history of the music's muSpectrum across a sequence of concentric circles.  The outward-flowing version (the spectra appear to start at the middle and progress outward) derives from the previous "DownTheRabbitHole" visualization.  And the inward-flowing version  (the spectra appear to start at the outside and progress inward) derives from the previous "OutOfTheRabbitHole" visualization.
///
/// The following activities are performed during each rendering cycle:
///     The 6-octave muSpectrum is computed.  It extends from C1 at 33 Hz to B6 at 1976 Hz. Each muSpectrum contains 72 x 12 = 864 points.
///     These spectral values are written into a buffer memory.
///     For the outward-flowing version, the most recent muSpectrum is rendered on the innermost 8 ellipses (to visually emphasize the newest audio).  And the next 47 muSpectra are read from this buffer memory and rendered along the outermost 47 of the 8 + 47 = 55 concentric ellipses.
///     For the inward-flowing version, the most recent muSpectrum is rendered on the outermost ellipse.  And the next 47 muSpectra are read from this buffer memory and rendered along the next-inner 47 ellipses.  The 48th (the oldest) muSpectrum is rendered on the innermost 8 ellipses.
///
///   Each muSpectrum is rendered around it's respective ellipse clockwise starting at the twelve o'clock position.
///
/// Again, the colors change with time. The color travels outward with the peaks.   If the optionOn button is selected, then a color gradient is applied to
/// each circle such that the notes within an octave are colored similarly to the standard "hue" color cycle.
///
/// For enhanced visual dynamics, we make the center of the ellipses move both vertically and horizontally.
///
/// Ever since Lewis Carroll wrote "Alice's Adventures in Wonderland" in 1865, the phrase "falling down the rabbit hole" has been a metaphor for something that transports someone into a wonderfully (or troublingly) surreal state or situation.  I have attempted to capture that feeling in this visualization.
///
//         foreground
// option0  in-to-out hue   outward-flowing (DownInto)
// option1  hueGradientX5   outward-flowing (DownInto)
// option2  in-to-out hue   outward-flowing (DownInto)  slow
// option3  hueGradientX5   outward-flowing (DownInto)  very slow
// option4  out-to-in hue   inward-flowing (OutOf)
// option5  hueGradientX5   inward-flowing (OutOf)
// option6  out-to-in hue   inward-flowing (OutOf)      slow
// option7  hueGradientX5   inward-flowing (OutOf)      very slow
///
/// Created by Keith Bromley on 1 June 2021. (adapted from his previous java version in the Polaris app)
/// Significantly updated on 26 Nov 2021.


import SwiftUI

struct RabbitHole: View {

    @EnvironmentObject var manager: AudioManager  // Observe the instance of AudioManager passed from ContentView
    @EnvironmentObject var settings: Settings
    @Environment(\.colorScheme) var colorScheme
    let noteProc = NoteProcessing()
    
    static var hueOld: [Double] = [Double](repeating: 0.0, count: 60)
    static var colorIndex: Int = 0
    
    var body: some View {
    
        // Toggle between black and white as the Canvas's background color:
        let backgroundColor: Color = (colorScheme == .dark) ? Color.black : Color.white
        
        Canvas { context, size in
 
            let width: Double  = size.width
            let height: Double = size.height
            let X0: Double = 0.5 * width   // the origin of the ellipses
            let Y0: Double = 0.5 * height  // the origin of the ellipses
            
            var startX: Double = 0.0        // horizontal center of the innermost ellipse
            var startY: Double = 0.0        // vertical   center of the innermost ellipse
            let endX: Double = X0           // horizontal center of the outermost ellipse
            let endY: Double = Y0           // vertical   center of the outermost ellipse

            let endRadius: Double = 0.8 * sqrt(X0 * X0 + Y0 * Y0)      // stretches from center to almost the corner
            let startRadius: Double = endRadius * 0.02                 // starting radius value
            let rangeRadius = endRadius - startRadius                  // range of the radius value

            var x : Double = 0.0       // The drawing origin is in the upper left corner.
            var y : Double = 0.0       // The drawing origin is in the upper left corner.
            var xOld : Double = 0.0
            var yOld : Double = 0.0

            var mag:  Double = 0.0         // used as a preliminary part of the audio amplitude value
            var magX: Double = 0.0         // used as a preliminary part of the audio amplitude value
            var magY: Double = 0.0         // used as a preliminary part of the audio amplitude value

            let innermostEllipseCount: Int = 12

            let dispHistoryCount: Int = 48      // displayedHistoryCount must be <= historyCount

            let ellipseCount: Int = dispHistoryCount + innermostEllipseCount  // 47 + 8 = 55

            let newestHist: Int = historyCount-1    // The newest line of data is at the end of the muSpecHistory array.
            let oldestHist: Int = 0           // The oldest line of data is at the beginning of the muSpecHistory array.

            var hist: Int = 0
            var histOffset: Int = 0
            var hue: Double = 0.0

            let colorSize: Int = 40    // This determines the frequency of the color change over time.
            RabbitHole.colorIndex = (RabbitHole.colorIndex >= colorSize) ? 0 : RabbitHole.colorIndex + 1
            let startHue360: Int = Int( 360.0 * Double(RabbitHole.colorIndex) / Double(colorSize) )

            // The following variables control the movement of the ellipse centers:
            let now = Date()
            let time = now.timeIntervalSinceReferenceDate
            let frequency: Double = 0.05  // 1 cycle per 20 seconds
            let offsetX: Double = cos(2.0 * Double.pi * 3.0*frequency * time ) // oscillates between -1 and +1
            let offsetY: Double = cos(2.0 * Double.pi *     frequency * time ) // oscillates between -1 and +1

            // Use local short name to improve code readablity:
            let muSpecHistory = manager.muSpecHistory
            let option = settings.option
            var outward: Bool = true        // used to denote code differences between inward and outward modes

            if(option < 4) { outward = true } else { outward = false }
            
            manager.skipHist =  ( option==3 || option==7 ) ? 2 :
                                ( option==2 || option==6 ) ? 1 : 0

// ---------------------------------------------------------------------------------------------------------------------
            if(outward == true) {
                // Make one pass through the ellipses to determine their color (Must be done in reverse order):
                for ellipseNum in (0 ..< ellipseCount).reversed()  {       //  0 <= ellipseNum < 64
                    let tempHue: Double = (ellipseNum < innermostEllipseCount) ? Double(startHue360) / 360.0 : RabbitHole.hueOld[ellipseNum-1]
                    RabbitHole.hueOld[ellipseNum] = tempHue
                }
            }

// ---------------------------------------------------------------------------------------------------------------------
            for ellipseNum in 0 ..< ellipseCount  {       //  0 <= ellipseNum < 55

                // ellipseNum == 0 is the innermost ellipse. We always render from the inside to the outside.

                // As ellipseNum goes from 0 to ellipseCount, ellipseRampUp goes from 0.0 to 1.0:
                let rampUp: Double = Double(ellipseNum) / Double(ellipseCount)
                let rampUp2: Double = rampUp * rampUp          // Deliberate non-linear radius.

                // As ellipseNum goes from 0 to ellipseCount, ellipseRampDown goes from 1.0 to 0.0:
                let rampDown: Double = Double(ellipseCount - ellipseNum) / Double(ellipseCount)

                let radius: Double = startRadius + (rampUp2 * rangeRadius) // non-linear radius

                // Just for enhanced visual dynamics, make the center of the ellipses move vertically and horizontally:
                startX = X0 + offsetX * (width  * 0.1)
                startY = Y0 + offsetY * (height * 0.1)

                xOld = rampDown * startX + rampUp * endX                    // Start at the twelve o'clock position
                yOld = rampDown * startY + rampUp * endY - radius           // Start at the twelve o'clock position

                // Now ensure that we read the correct spectral data from the muSpecHistory[] array:
                
                if(outward==true) {
                    hist = (ellipseNum <= innermostEllipseCount) ?  0 : ellipseNum - innermostEllipseCount
                    histOffset = (newestHist - hist) * sixOctPointCount     // use this for outward flowing spectra
                    hue = ( ellipseNum < innermostEllipseCount) ?		    // in-to-out hue
                            Double(startHue360) / 360.0 :
                            RabbitHole.hueOld[ellipseNum-1]                 // 0.0 <= hue < 1.0
                }else{
                    hist = (ellipseNum <= innermostEllipseCount) ?  0 : ellipseNum - innermostEllipseCount
                    histOffset = (oldestHist + hist) * sixOctPointCount     // use this for inward  flowing spectra
                    hue = ( ellipseNum == ellipseCount-1) ?                 // out-to-in hue
                            Double(startHue360) / 360.0 :
                            RabbitHole.hueOld[ellipseNum+1]                 // 0.0 <= hue < 1.0
                    RabbitHole.hueOld[ellipseNum] = hue
                }

                var path = Path()
                path.move( to: CGPoint( x: xOld, y: yOld ) )

                // Render the 864 points in each ellipse:
                for point in 0 ..< sixOctPointCount {
                    let tempIndex: Int = histOffset + point
                    mag = 0.1 * Double( muSpecHistory[tempIndex] )
                    mag = min(max(0.0, mag), 1.0)   // Limit over- and under-saturation.
                    magX = mag * rampUp2 * width    // The spectral peaks get bigger at the outer rings
                    magY = mag * rampUp2 * height   // The spectral peaks get bigger at the outer rings
                    // Set to point=0 being at the twelve o'clock position:
                    x = (rampDown * startX + rampUp * endX) + (radius - magX) * noteProc.sin2PiTheta[point]
                    y = (rampDown * startY + rampUp * endY) - (radius - magY) * noteProc.cos2PiTheta[point]
                    path.addLine(to: CGPoint(x: x,  y: y ) )
                }  // end of for() loop over point

                if(option==0 || option==2 || option==4 || option==6) {
                    context.stroke( path,                                           // either in-to-out or out-to-in hue
                                    with: .color( Color(hue: hue, saturation: 1.0, brightness: 1.0) ),
                                    lineWidth: 0.5 +  rampUp2 * 4.0 )
                }
                else {
                    // Stroke the 48 paths with an angular gradient cycling through 6 cycles of the "hue" colors:
                    context.stroke( path,                                                           // hue6GradientX5
                                    with: .conicGradient( hue6GradientX5,
                                                          center: CGPoint( x: startX, y: startY ),
                                                          angle: Angle(degrees: 270.0) ),
                                    lineWidth: 0.5 +  rampUp2 * 4.0 )
                    // https://devtechie.medium.com/new-in-swiftui-3-canvas-269c64ef5efc
                    // https://swiftui-lab.com/swiftui-animations-part5/
                }
                
            }  // end of for() loop over ellipseNum

        }  // end of Canvas
        .background(backgroundColor)  // Toggle between black and white background color.
        
    }  // end of var body: some View
}  // end of RabbitHole struct
