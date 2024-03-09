//
//  ViewUtilities.swift
//  MuVis
//
//  Created by Treata Norouzi on 3/9/24.
//

import SwiftUI

// https://stackoverflow.com/questions/56786163/swiftui-how-to-draw-filled-and-stroked-shape
extension Shape {
    public func fill<Shape: ShapeStyle>(
        _ fillContent: Shape,
        strokeColor  : Color,
        lineWidth    : CGFloat

    ) -> some View {
        ZStack {
            self.fill(fillContent)
            self.stroke( strokeColor, lineWidth: lineWidth)

        }
    }
}



// https://www.swiftbysundell.com/articles/stroking-and-filling-a-swiftui-shape-at-the-same-time/
extension Shape {
    func style<S: ShapeStyle, F: ShapeStyle>(
        withStroke strokeContent: S,
        lineWidth: CGFloat = 1,
        fill fillContent: F
    ) -> some View {
        self.stroke(strokeContent, lineWidth: lineWidth)
    .background(fill(fillContent))
    }
}
