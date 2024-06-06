//  VisUtilities.swift
//  MuVis
//
//  This file contains several utility extensions, structs, and funcs that are used by several of the Visualizations.
//
//  Created by Keith Bromley on 10/21/21.


import Foundation
import SwiftUI



struct HorizontalLines: View {
    @Environment(\.colorScheme) var colorScheme
    var rowCount: Int
    var offset: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let rowHeight : CGFloat = height / CGFloat(rowCount)
            
            //  Draw 8 horizontal lines across the pane (separating the 7 octaves):
            ForEach( 0 ..< rowCount+1, id: \.self) { row in        //  0 <= row < 7+1
            
                Path { path in
                path.move(   to: CGPoint(x: CGFloat(0.0), y: CGFloat(row) * rowHeight - offset * rowHeight) )
                path.addLine(to: CGPoint(x: width,        y: CGFloat(row) * rowHeight - offset * rowHeight) )
                }
                .stroke(lineWidth: 1.0)
                .foregroundColor( (colorScheme == .light) ? .lightGray : .black )
            }
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of HorizontalLines struct



struct VerticalLines: View {
    @Environment(\.colorScheme) var colorScheme
    var columnCount: Int

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let columnWidth : CGFloat = width / CGFloat(columnCount)
            
            //  Draw 12 vertical lines across the pane (separating the 12 notes):
            ForEach( 0 ..< columnCount+1, id: \.self) { column in        //  0 <= column < 11+1
            
                Path { path in
                    path.move(   to: CGPoint(x: CGFloat(column) * columnWidth, y: CGFloat(0.0)) )
                    path.addLine(to: CGPoint(x: CGFloat(column) * columnWidth, y: height) )
                }
                .stroke(lineWidth: 1.0)
                .foregroundColor( (colorScheme == .light) ? .lightGray : .black )
            }
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of VerticalLines struct



// Render vertical gray rectangles on the screen to denote the keyboard underlay:
// Used in the MusicSpectrum, muSpectrum, LinearOAS, OverlappedOctaves, OctaveAlignedSpectrum, OctaveAlignedSpectrum_both,
// HarmonicAlignment, HarmonicAlignment2, TriOctSpectrum, TriOctMuSpectrum, Waterfall, and MuSpectrogram visualizations.
struct GrayVertRectangles: View {
    @Environment(\.colorScheme) var colorScheme
    var columnCount: Int

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let columnWidth : CGFloat = width / CGFloat(columnCount)

            ForEach( 0 ..< columnCount, id: \.self) { columnNum in        //  0 <= column < 12 or 36 or 72 or 96
                // For each octave, draw 5 rectangles across the pane (representing the 5 accidentals (i.e., sharp/flat notes):
                if(accidentalNotes[columnNum%12] == true) {
                    // The accidentalNotes array is a global variable declared in MuVisApp.swift.
                    // This condition selects the column values for the notes C#, D#, F#, G#, and A#.
                    Rectangle()
                        .fill( (colorScheme == .light) ? Color.lightGray : Color.black )
                        .frame(width: columnWidth, height: height)
                        .offset(x: CGFloat(columnNum) * columnWidth, y: 0.0)
                }
            }
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of GrayVertRectangles struct



// Render horizontal gray rectangles on the screen to denote the keyboard underlay:
// Used in the MuSpectrogram visualization.
struct GrayHorRectangles: View {
    @Environment(\.colorScheme) var colorScheme
    var rowCount: Int

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let rowHeight : CGFloat = height / CGFloat(rowCount)

            ForEach( 0 ..< rowCount, id: \.self) { rowNum in        //  0 <= row < 12 or 36 or 72 or 96
                // For each octave, draw 5 rectangles across the pane (representing the 5 accidentals (i.e., sharp/flat notes):
                if(accidentalNotes[rowNum] == true) {
                    // The accidentalNotes array is a global variable declared in MuVisApp.swift.
                    // This condition selects the column values for the notes C#, D#, F#, G#, and A#.
                    Rectangle()
                        .fill( (colorScheme == .light) ? Color.lightGray : Color.black )
                        .frame(width: width, height: rowHeight)
                        .offset(x: 0.0, y: CGFloat(rowNum) * rowHeight)
                }
            }
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of GrayHorRectangles struct



struct ColorRectangles: View {
    var columnCount: Int
    
    var body: some View {
        GeometryReader { geometry in
        
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let columnWidth : CGFloat = width / CGFloat(columnCount)

            // Fill 36 colored rectangles across the pane.
            HStack(alignment: .center, spacing: 0.0) {
            
                ForEach( 0 ..< columnCount, id: \.self) { column in        //  0 <= rect < 36
                    let noteNum = column % notesPerOctave
                    Rectangle()
                        .fill(noteColor[noteNum])                           // The noteColor array is defined below.
                        .frame(width: columnWidth, height: height)
                }
            }
        }  // end of GeometryReader
    }  // end of var body: some View
}  // end of ColorRectangles struct



struct HorizontalNoteNames: View { // used in LinearOAS, OverlappedOctaves, OctaveAlignedSpectrum, HarmonicsAlignment,
    // HarmonicAlignment2, TriOctSpectrum, TriOctMuSpectrum, OverlappedHarmonics, Watefall, and Waterfall2 visualizations
    var rowCount: Int
    var octavesPerRow: Int
    
    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width   // The drawing origin is in the upper left corner.
            let height: CGFloat = geometry.size.height  // The drawing origin is in the upper left corner.
            let octaveWidth: CGFloat = width / CGFloat(octavesPerRow)
            let noteWidth: CGFloat = width / CGFloat(octavesPerRow * notesPerOctave)
            
            ForEach(0 ..< rowCount, id: \.self) { rows in
                let row = CGFloat(rows)
                
                  ForEach(0 ..< octavesPerRow, id: \.self) { octave in
                    let oct = CGFloat(octave)
                    
                    Text("C")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 0 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("D")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 2 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("E")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 4 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("F")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 5 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("G")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 7 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("A")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 9 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                    Text("B")
                        .frame(width: noteWidth, height: 0.05*height)
                        .offset(x: oct * octaveWidth + 11 * noteWidth, y: 0.95 * row * height)
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
}



struct VerticalNoteNames: View {    // used in Waterfall2 visualization
    var columnCount: Int
    var octavesPerColumn: Int

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            let octaveHeight: CGFloat = height / CGFloat(octavesPerColumn)
            let noteHeight: CGFloat = height / CGFloat(octavesPerColumn * notesPerOctave)

            ForEach(0 ..< columnCount, id: \.self) { columns in
                let column = CGFloat(columns)

                  ForEach(0 ..< octavesPerColumn, id: \.self) { octave in
                    let oct = CGFloat(octave)

                    Text("C")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 1 * noteHeight ))
                        .minimumScaleFactor(0.5)
                    Text("D")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 3 * noteHeight))
                        .minimumScaleFactor(0.5)
                    Text("E")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 5 * noteHeight))
                        .minimumScaleFactor(0.5)
                    Text("F")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 6 * noteHeight))
                        .minimumScaleFactor(0.5)
                    Text("G")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 8 * noteHeight))
                        .minimumScaleFactor(0.5)
                    Text("A")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 10 * noteHeight))
                        .minimumScaleFactor(0.5)
                    Text("B")
                        .frame(width: 0.05*width, height: noteHeight)
                        .offset(x: 0.96 * column * width, y: height - (oct * octaveHeight + 12 * noteHeight))
                        .minimumScaleFactor(0.5)
                }
            }
        }
    }
}



struct EllipticalNoteNames: View {    // used in EllipticalOAS and SpiralOAS visualizations

    var body: some View {
        GeometryReader { geometry in
            let width: CGFloat  = geometry.size.width
            let height: CGFloat = geometry.size.height
            let X0: CGFloat = width  / 2.0  // the origin of the ellipses
            let Y0: CGFloat = height / 2.0  // the origin of the ellipses
            let A0: CGFloat = width  / 2.0  // the horizontal radius of the largest ellipse
            let B0: CGFloat = height / 2.0  // the vertical   radius of the largest ellipse

            let naturalNote: [Int] = [0, 2, 4, 5, 7, 9, 11]     // angle value preceding notes C, D, E, F, G, A, and B
            let naturalNoteNames: [String] = ["C", "D", "E", "F", "G", "A", "B"]     // names of the natural notes
            
            ForEach(0 ..< naturalNote.count, id: \.self) { note in
                let theta1 = Double(naturalNote[note])   / Double(notesPerOctave)   // 0.0 <= theta1 < 1.0
                let theta2 = Double(naturalNote[note]+1) / Double(notesPerOctave)   // 0.0 <= theta2 < 1.0
                let theta = (theta1 + theta2) * 0.5
                let x = X0 + 0.96 * A0 * CGFloat(sin(2.0 * Double.pi * theta))           // 0 <= theta <= 1
                let y = Y0 - 0.96 * B0 * CGFloat(cos(2.0 * Double.pi * theta))           // 0 <= theta <= 1

                Text("\(naturalNoteNames[note])")
                    .position(x: x, y: y)
                    .font(.largeTitle)      // https://sarunw.com/posts/swiftui-text-font/
            }
        }
    }
}

// MARK: - ColorPane

/// used in the TriOctSpectrum visualization
struct ColorPane: View {
    var color: Color
    var body: some View {
        Canvas(rendersAsynchronously: true) { context, size in

        context.fill(
            Path(CGRect(x: 0, y: 0.0, width: size.width, height: size.height)),
            with: .color(color) )
        }
    }
}
