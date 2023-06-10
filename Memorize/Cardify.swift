//
//  Cardify.swift
//  Memorize
//
//  Created by user on 6/8/23.
//

import SwiftUI

/// A view modifier that draws the given `content` on the face of a card.
struct Cardify: ViewModifier {
    /// Whether to show the face or the back of the card.
    var isFaceUp: Bool
    /// Colors to fill the back of the card.
    var colors: [Color]

    /// Returns the body of the modified view.
    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
            } else {
                shape.fill(Gradient(colors: colors))
            }
            content.opacity(isFaceUp ? 1 : 0)
        }
    }

    /// Constants that determine card appearance.
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 1
    }
}

extension View {
    /// Returns a view that looks card-like view with the contents of the original view shown on its face.
    func cardify(isFaceUp: Bool, colors: [Color]) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, colors: colors))
    }
}
