//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

/// The main view of the app.
struct EmojiMemoryGameView: View {
    /// A reference to the view model.
    @ObservedObject var game: EmojiMemoryGame
    /// The body of the view.
    var body: some View {
        VStack {
            Text(game.currentThemeName).font(.largeTitle)
            Text("Score: \(game.currentScore)")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card, colors: game.currentThemeColors).aspectRatio(2/3, contentMode: .fit).onTapGesture {
                            game.choose(card)
                        }
                    }
                }}
            .padding(.horizontal)
            Button {
                game.resetGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle").font(.largeTitle)
            }
        }
    }
}

/// A view that represents a single card.
struct CardView: View {
    /// The card model.
    let card: EmojiMemoryGame.Card
    /// Colors to fill the back of the card.
    let colors: [Color]
    /// The body of the view.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill(Gradient(colors: colors))
                }
            }
        }
    }
    /// Returns a `Font` that fits the given `size`.
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
    }
    /// Constants that determine card appearance.
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 1
        static let fontScale: CGFloat = 0.75
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
    }
}
