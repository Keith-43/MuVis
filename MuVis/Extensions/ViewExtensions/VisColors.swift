//  VisColors.swift
//  MuVis
//
//  This file contains several useful color schemes that are used by several of the Visualizations.
//
//  SwiftUI Standard colors: black,blue,brown,clear,cyan,gray,green,indigo,mint,orange,pink,purple,red,teal,white,yellow
//
//  In light mode, natural notes are colored white,    and accidental notes are colored lightGray.
//  In dark  mode, natural notes are colored darkGray, and accidental notes are colored black.
//
//  Created by Keith Bromley in May 2023.
//

import Foundation
import SwiftUI

// Define note colors for the 12 notes of the equal-tempered scale:
extension Color {
    static let lightGray        = Color(red: 0.8, green: 0.8, blue: 0.8)    // denotes accidental notes in keyboard overlay in light mode
    static let darkGray         = Color(red: 0.6, green: 0.6, blue: 0.6)    // denotes natural notes in keyboard overlay in dark mode


    // Define  note colors for the 12 notes of the equal-tempered scale (using HSB):
    static let noteC_Color      = Color(hue:  0.0,      saturation: 1.0, brightness: 1.0)    // red
    static let noteCsharp_Color = Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0)
    static let noteD_Color      = Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0)    // yellow
    static let noteDsharp_Color = Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0)
    static let noteE_Color      = Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0)    // green
    static let noteF_Color      = Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0)
    static let noteFsharp_Color = Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0)    // cyan
    static let noteG_Color      = Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0)
    static let noteGsharp_Color = Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0)    // blue
    static let noteA_Color      = Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0)
    static let noteAsharp_Color = Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0)    // magenta
    static let noteB_Color      = Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0)


    // Define half-opacity note colors  for more-subtle usage (e.g., current note):
    static let noteC_ColorHO      = Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 0.4)    // red
    static let noteCsharp_ColorHO = Color(red: 1.0, green: 0.5, blue: 0.0, opacity: 0.4)
    static let noteD_ColorHO      = Color(red: 1.0, green: 1.0, blue: 0.0, opacity: 0.4)    // yellow
    static let noteDsharp_ColorHO = Color(red: 0.5, green: 1.0, blue: 0.0, opacity: 0.4)
    static let noteE_ColorHO      = Color(red: 0.0, green: 1.0, blue: 0.0, opacity: 0.4)    // green
    static let noteF_ColorHO      = Color(red: 0.0, green: 1.0, blue: 0.5, opacity: 0.4)
    static let noteFsharp_ColorHO = Color(red: 0.0, green: 1.0, blue: 1.0, opacity: 0.4)    // cyan
    static let noteG_ColorHO      = Color(red: 0.0, green: 0.5, blue: 1.0, opacity: 0.4)
    static let noteGsharp_ColorHO = Color(red: 0.0, green: 0.0, blue: 1.0, opacity: 0.4)    // blue
    static let noteA_ColorHO      = Color(red: 0.5, green: 0.0, blue: 1.0, opacity: 0.4)
    static let noteAsharp_ColorHO = Color(red: 1.0, green: 0.0, blue: 1.0, opacity: 0.4)    // magenta
    static let noteB_ColorHO      = Color(red: 1.0, green: 0.0, blue: 0.5, opacity: 0.4)


    // Define half-intensity note colors for more-subtle usage (e.g., current note):
    static let noteC_ColorHI      = Color(hue:  0.0,      saturation: 1.0, brightness: 0.4)    // red
    static let noteCsharp_ColorHI = Color(hue:  1.0/12.0, saturation: 1.0, brightness: 0.4)
    static let noteD_ColorHI      = Color(hue:  2.0/12.0, saturation: 1.0, brightness: 0.4)    // yellow
    static let noteDsharp_ColorHI = Color(hue:  3.0/12.0, saturation: 1.0, brightness: 0.4)
    static let noteE_ColorHI      = Color(hue:  4.0/12.0, saturation: 1.0, brightness: 0.4)    // green
    static let noteF_ColorHI      = Color(hue:  5.0/12.0, saturation: 1.0, brightness: 0.4)
    static let noteFsharp_ColorHI = Color(hue:  6.0/12.0, saturation: 1.0, brightness: 0.4)    // cyan
    static let noteG_ColorHI      = Color(hue:  7.0/12.0, saturation: 1.0, brightness: 0.4)
    static let noteGsharp_ColorHI = Color(hue:  8.0/12.0, saturation: 1.0, brightness: 0.4)    // blue
    static let noteA_ColorHI      = Color(hue:  9.0/12.0, saturation: 1.0, brightness: 0.4)
    static let noteAsharp_ColorHI = Color(hue: 10.0/12.0, saturation: 1.0, brightness: 0.4)    // magenta
    static let noteB_ColorHI      = Color(hue: 11.0/12.0, saturation: 1.0, brightness: 0.4)
}



let noteColor: [Color] = [  Color.noteC_Color, Color.noteCsharp_Color, Color.noteD_Color, Color.noteDsharp_Color,
                            Color.noteE_Color, Color.noteF_Color, Color.noteFsharp_Color, Color.noteG_Color,
                            Color.noteGsharp_Color, Color.noteA_Color, Color.noteAsharp_Color, Color.noteB_Color ]
// These colors are used in the PianoKeyboard, TriOctSpectrum, and OverlappedHarmonics visualizations.



let noteColorHO: [Color] = [  Color.noteC_ColorHO, Color.noteCsharp_ColorHO, Color.noteD_ColorHO, Color.noteDsharp_ColorHO,
                            Color.noteE_ColorHO, Color.noteF_ColorHO, Color.noteFsharp_ColorHO, Color.noteG_ColorHO,
                            Color.noteGsharp_ColorHO, Color.noteA_ColorHO, Color.noteAsharp_ColorHO, Color.noteB_ColorHO ]
// These colors are used in the (TBD) visualizations.



let noteColorHI: [Color] = [  Color.noteC_ColorHI, Color.noteCsharp_ColorHI, Color.noteD_ColorHI, Color.noteDsharp_ColorHI,
                            Color.noteE_ColorHI, Color.noteF_ColorHI, Color.noteFsharp_ColorHI, Color.noteG_ColorHI,
                            Color.noteGsharp_ColorHI, Color.noteA_ColorHI, Color.noteAsharp_ColorHI, Color.noteB_ColorHI ]
// These colors are used in the (TBD) visualizations.



// Convert a hueValue to RGB colors:     // 0.0 <= hueValue <= 1.0
// This function is used in the Cymbal visualization.
func HtoRGB( hueValue: Double ) -> (redValue: Double, greenValue: Double, blueValue: Double) {
    var redValue:   Double = 0.0
    var greenValue: Double = 0.0
    var blueValue:  Double = 0.0
    let hue: Double = hueValue * 6.0

    if       (hue <= 1.0)   { redValue = 1.0;       greenValue = hue;       blueValue = 0.0
    }else if (hue <  2.0)   { redValue = 2.0 - hue; greenValue = 1.0;       blueValue = 0.0
    }else if (hue <  3.0)   { redValue = 0.0;       greenValue = 1.0;       blueValue = hue - 2.0
    }else if (hue <  4.0)   { redValue = 0.0;       greenValue = 4.0 - hue; blueValue = 1.0
    }else if (hue <  5.0)   { redValue = hue - 4.0; greenValue = 0.0;       blueValue = 1.0
    }else                   { redValue = 1.0;       greenValue = 0.0;       blueValue = 6.0 - hue
    }
    return (redValue, greenValue, blueValue)
}  // end of HtoRGB() func



// Convert a hueValue to RGB colors (for a white background):     // 0.0 <= hueValue <= 1.0
// Used in Spectrogram visualization.
func HtoRGB_white   ( hueValue: Double) -> (redValue: Double, greenValue: Double, blueValue: Double) {
    var redValue:   Double = 0.0
    var greenValue: Double = 0.0
    var blueValue:  Double = 0.0
    let hue: Double = hueValue * 6.0            // hue goes from 0.0 to 6.0 as hueValue goes from 0.0 to 1.0

    if       (hue <= 1.0)   { redValue = 1.0;       greenValue = 1.0;       blueValue = 1.0 - hue
    }else if (hue <  2.0)   { redValue = 2.0 - hue; greenValue = 1.0;       blueValue = 0.0
    }else if (hue <  3.0)   { redValue = 0.0;       greenValue = 1.0;       blueValue = hue - 2.0
    }else if (hue <  4.0)   { redValue = 0.0;       greenValue = 4.0 - hue; blueValue = 1.0
    }else if (hue <  5.0)   { redValue = hue - 4.0; greenValue = 0.0;       blueValue = 1.0
    }else                   { redValue = 1.0;       greenValue = 0.0;       blueValue = 6.0 - hue
    }

    return (redValue, greenValue, blueValue)

}  // end of HtoRGB_white() func



// Convert a hueValue to RGB colors (for a black background):     // 0.0 <= hueValue <= 1.0
// Used in Spectrogram visualization.
func HtoRGB_black   ( hueValue: Double) -> (redValue: Double, greenValue: Double, blueValue: Double) {
    var redValue:   Double = 0.0
    var greenValue: Double = 0.0
    var blueValue:  Double = 0.0
    let hue: Double = 6.0 - (hueValue * 6.0)    // hue goes from 6.0 to 0.0 as hueValue goes from 0.0 to 1.0

    if       (hue <= 1.0)   { redValue = 1.0;       greenValue = hue;       blueValue = 0.0
    }else if (hue <  2.0)   { redValue = 2.0 - hue; greenValue = 1.0;       blueValue = 0.0
    }else if (hue <  3.0)   { redValue = 0.0;       greenValue = 1.0;       blueValue = hue - 2.0
    }else if (hue <  4.0)   { redValue = 0.0;       greenValue = 4.0 - hue; blueValue = 1.0
    }else if (hue <  5.0)   { redValue = hue - 4.0; greenValue = 0.0;       blueValue = 1.0
    }else                   { redValue = 6.0 - hue; greenValue = 0.0;       blueValue = 6.0 - hue
    }

    return (redValue, greenValue, blueValue)  // Each is a double value between 0.0 and 1.0

}  // end of HtoRGB_black() func


/*
                   red        yellow      green        cyan       blue       magenta       red
         hueValue = 0          1/6         2/6         3/6         4/6         5/6          1
              hue = 6           5           4           3           2           1           0
                    |-----------|-----------|-----------|-----------|-----------|-----------|
 
      white        red        yellow      green        cyan       blue       black
kuVal = 0          1/6         2/6         3/6         4/6         5/6          1
  kue = 6           5           4           3           2           1           0
        |-----------|-----------|-----------|-----------|-----------|-----------|
*/

// Convert a hueValue to RGB colors (through: black, blue, cyan, green, yellow, red, white):     // 0.0 <= hueValue <= 1.0
// Used in Spectrogram visualization.
func HtoRGB_WRYGCBB   ( hueValue: Double) -> (redValue: Double, greenValue: Double, blueValue: Double) {
    var redValue:   Double = 0.0
    var greenValue: Double = 0.0
    var blueValue:  Double = 0.0
    let hue: Double = 6.0 - (hueValue * 6.0)    // hue goes from 6.0 to 0.0 as hueValue goes from 0.0 to 1.0

    if       (hue <= 1.0)   { redValue = 0.0;       greenValue = 0.0;       blueValue = hue         // black to blue
    }else if (hue <  2.0)   { redValue = 0.0;       greenValue = hue - 1.0; blueValue = 1.0         // blue to cyan
    }else if (hue <  3.0)   { redValue = 0.0;       greenValue = 1.0;       blueValue = 3.0 - hue   // cyan to green
    }else if (hue <  4.0)   { redValue = hue - 3.0; greenValue = 1.0;       blueValue = 0.0         // green to yellow
    }else if (hue <  5.0)   { redValue = 1.0;       greenValue = 5.0 - hue; blueValue = 0.0         // yellow to red
    }else                   { redValue = 1.0;       greenValue = hue - 5.0; blueValue = hue - 5.0   // red to white
    }

    return (redValue, greenValue, blueValue)  // Each is a double value between 0.0 and 1.0

}  // end of HtoRGB_WRYGCBB() func



// This func allows me to use a HSB color in the format of a gradient:
// This is used in the RainbowEllipse and SpinningEllipse visualizations.
func hueToGradient( hueValue: Double) -> Gradient {
    let hue: Double = hueValue
    return ( Gradient(colors: [Color(hue: hue, saturation: 1.0, brightness: 1.0) ] ) )
}



/*  Cycling through the 6 "hue" colors is a convenient representation for cycling through the 12 notes of an octave:
       red        yellow      green        cyan       blue       magenta       red
  hue = 0          1/6         2/6         3/6         4/6         5/6          1
        |-----------|-----------|-----------|-----------|-----------|-----------|
 note = 0     1     2     3     4     5     6     7     8     9    10    11     0
        C     C#    D     D#    E     F     F#    G     G#    A     A#    B     C
*/



// Define a Gradient that cycles through the same color sequence as the standard "hue":
// This is used in the OctaveAlignedSpectrum, EllipticalOAS, SpiralOAS, TriOctMuSpectrum, RainbowSpectrum, RaibowOAS,
// RainbowEllipse, and SpinningEllipse visualizations.
let hueGradient: Gradient = Gradient(colors: [Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                              Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                              Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                              Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                              Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                              Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                              Color(red: 1.0, green: 0.0, blue: 0.0) ] )  // red



let hueGradientHue: Gradient = Gradient(colors: [Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0) ] )



let hueGradientX5: Gradient = Gradient(colors: [Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0) ] )



let hue3GradientX5: Gradient = Gradient(colors: [Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0) ] )



// Define a Gradient that cycles 3 times through the same color sequence as the standard "hue":
// This is used in the TriOctMuSpectrum, RainbowSpectrum, RainbowSpectrum2, and Waterfall visualizations.
let hue3Gradient: Gradient = Gradient(colors: [Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0)])    // red
                                              
                                              
// Define a Gradient that cycles 6 times through the same color sequence as the standard "hue":
// This is used in the SpinningEllipse, OutOfTheRabbitHole, and DownTheRabbitHole visualizations.
let hue6Gradient: Gradient = Gradient(colors: [Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0),     // red
                                               Color(red: 1.0, green: 1.0, blue: 0.0),     // yellow
                                               Color(red: 0.0, green: 1.0, blue: 0.0),     // green
                                               Color(red: 0.0, green: 1.0, blue: 1.0),     // cyan
                                               Color(red: 0.0, green: 0.0, blue: 1.0),     // blue
                                               Color(red: 1.0, green: 0.0, blue: 1.0),     // magenta
                                               Color(red: 1.0, green: 0.0, blue: 0.0)])    // red



let hue6GradientX5: Gradient = Gradient(colors: [Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  0.0,      saturation: 1.0, brightness: 1.0),    // red
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  1.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  2.0/12.0, saturation: 1.0, brightness: 1.0),    // yellow
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  3.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  4.0/12.0, saturation: 1.0, brightness: 1.0),    // green
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  5.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  6.0/12.0, saturation: 1.0, brightness: 1.0),    // cyan
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  7.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  8.0/12.0, saturation: 1.0, brightness: 1.0),    // blue
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue:  9.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 10.0/12.0, saturation: 1.0, brightness: 1.0),   // magenta
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0),
                                                 Color(hue: 11.0/12.0, saturation: 1.0, brightness: 1.0) ] )


//----------------------------------------------------------------------------------------------------------------------

extension Color {
    /// #SyntacticSugar
    init(_ red: Double, _ green: Double, _ blue: Double) {
        self.init(red: red/255, green: green/255, blue: blue/255)
    }
}
    
extension Color {
    static let prussianBlue = Color(15, 48, 91)
    static let blueSapphire = Color(27, 86, 177)
    static let almond = Color(171, 120, 78)
    static let caramel = Color(182, 114, 51)
    static let greenEye = Color(125, 149, 109)
    static let slateGray = Color(87, 92, 98)
    static let charcoalGray = Color(53, 55, 57)
    static let steel = Color(81, 81, 81)
    static let shadowGray = Color(41, 42, 47)
    static let midnightGray = Color(36, 39, 48)
    static let cream = Color(252, 249, 232)
}
