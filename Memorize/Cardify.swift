//
//  Cardify.swift
//  Memorize
//
//  Created by user on 6/8/23.
//

import SwiftUI

/// A view modifier that draws the given `content` on the face of a card.
struct Cardify: Animatable, ViewModifier {
    /// Rotation angle of the card in degrees.
    var rotation: Double
    /// The color to fill the back of the card.
    var color: Color
    /// Animatable property which is an alias for rotation.
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(isFaceUp: Bool, color: Color) {
        rotation = isFaceUp ? 0 : 180
        self.color = color
    }

    /// Returns the body of the modified view.
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill(color)
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }

    /// Constants that determine card appearance.
    private enum DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 1
    }
}

extension View {
    /// Returns a view that looks card-like view with the contents of the original view shown on its face.
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
