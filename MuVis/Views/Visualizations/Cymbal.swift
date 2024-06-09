/// Cymbal.swift
/// MuVis
///
/// The Cymbal visualization is a different way of depicting the current muSpectrum. It was inspired by contemplating the vibrational patterns of a cymbal.
/// It is purely an aesthetic depiction (with no attempt at real-world modeling).
///
/// We calculated the muSpectrum using 12 points per note.  For this visualization, we are going to subsample this by a factor of 6.  We do this in a way that makes
/// half of the subsampled points directly on the note centers, and and the remainder being directly at the note boundaries.
///
/// We render 6 octaves of the muSpectrum at 12 notes/octave and 12 points/note. Thus, each muSpectrum contains 6 x 12 x 12 = 864 points.
/// This Cymbal visualization renders 144 concentric circles (all with their origin at the pane center) with their radius proportional to these 144 musical-frequency points.
/// 72 of these are note centers, and 72 are the interspersed inter-note midpoints. We dynamically change the line width of these circles to denote the muSpectrum
/// amplitude.
///
/// For aesthetic effect, we overlay a plot of the current muSpectrum (replicated from mid-screen to the right edge and from mid-screen to the left edge)
/// on top of the circles.  The option selection changes the color of this muSpectrum plot.
///
/// The option button also allows the user to choose to render either ovals (wherein all of the shapes are within the visualization pane) or circles (wherein the top
/// and bottom are clipped as outside of the visualization pane).  This distinction is most easily observed in either short wide panes or tall thin panes.
///
//          Shape   ShapeColor  muSpectrum
// option0  circle  hue         red
// option1  circle  red         blue
// option2  circle  hue         green
// option3  circle  green       red
// option4  oval    hue         red
// option5  oval    red         blue
// option6  oval    hue         green
// option7  oval    green       red
///
/// Created by Keith Bromley in June 2021. (adapted from his previous java version in the Polaris app).   Significantly updated in Nov 2021, and May 2023.


import SwiftUI

// TODO: Optimize, runs barely at 20fps fullscreen

struct Cymbal: View {
    @Environment(AudioManager.self) private var manager: AudioManager
    @Environment(Settings.self) private var settings: Settings
    
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        GeometryReader {
            let size = $0.size

            let ellipseCount: Int = 144
            let width: CGFloat = size.width
            let height: CGFloat = size.height
            let halfWidth:  CGFloat = 0.5 * width
            let halfHeight: CGFloat = 0.5 * height

            var x: Double = 0.0        // The drawing origin is in the upper left corner.
            var y: Double = 0.0        // The drawing origin is in the upper left corner.
            var mag: Double = 0.0       // used as a preliminary part of the audio amplitude value

            // Use local short name to improve code readablity:
            let option = settings.option
            let muSpectrum = manager.muSpectrum

            // ---------------------------------------------------------------------------------------------------------
            // Render the 144 concentric ellipses:
            ForEach(0 ..< ellipseCount, id: \.self) { ellipseNum in      //  0 <= ellipseNum < 144

                // As ellipseNum goes from 0 to ellipseCount, rampUp goes from 0.0 to 1.0:
                let rampUp = Double(ellipseNum) / Double(ellipseCount)

                let hue = CGFloat(ellipseNum % 12) / 12.0
                let result = HtoRGB(hueValue: hue)

                let hueColor = Color(red: result.redValue, green: result.greenValue, blue: result.blueValue)

                Ellipse()
                    .stroke( (option==1 || option==5) ? Color.red : (option==3 || option==7) ? Color.green : hueColor,
                            lineWidth: 5.0 * max(0.0 , Double( muSpectrum[ 6 * ellipseNum ] ) ) )
                    .frame(width: rampUp * width, height: (option > 3) ? rampUp * height : rampUp * width )
                    .position(x: halfWidth, y: halfHeight)

            }

            // ---------------------------------------------------------------------------------------------------------
            // Now render a four-fold muSpectrum[] across the middle of the pane:
            ForEach(0 ..< 2, id: \.self) { row in          // We have a lower and an upper row.
                ForEach(0 ..< 2, id: \.self) { column in   // We have a left and a right column.
                
                    // Make the spectrum negative for the lower row:
                    let spectrumHeight = (row == 0) ? -0.1 * height : 0.1 * height
                    
                    // Make the spectrum go to the left for left column:
                    let spectrumWidth = (column == 0) ? -halfWidth : halfWidth
                        
                    Path { path in
                        path.move(to: CGPoint( x: halfWidth, y: halfHeight ) )
                        
                        for point in 0 ..< sixOctPointCount {
                            let upRamp =  Double(point) / Double(sixOctPointCount)
                            x = halfWidth + upRamp * spectrumWidth
                            mag = Double(muSpectrum[point]) * spectrumHeight
                            y = halfHeight + mag
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    .stroke(
                        Color((option==0 || option==4) ? .red :
                              (option==1 || option==5) ? .blue :
                              (option==2 || option==6) ? .green : .red),
                        lineWidth: 2)

                }  // end of ForEach() loop over column
            }  // end of ForEach() loop over row
            
        }  // end of GeometryReader
        .background(colorScheme == .dark ? .black : .white)     // Toggle between black and white background color.
        
    }  // end of var body: some View{}
}

#Preview("Cymbal") {
    Cymbal()
        .enhancedPreview()
}
