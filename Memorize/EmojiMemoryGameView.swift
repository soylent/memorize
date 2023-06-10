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

    @State private var dealt = Set<Int>()

    private func dealCards() {
        dealt.removeAll()
        withAnimation {
            for card in game.cards {
                dealt.insert(card.id)
            }
        }
    }

    private func isDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        dealt.contains(card.id)
    }

    /// The body of the view.
    var body: some View {
        VStack {
            Text(game.currentThemeName).font(.largeTitle)
            Text("Score: \(game.currentScore)")
            cardGrid
            bottomMenu
        }
        .padding(.horizontal)
    }

    private var cardGrid: some View {
        AspectVGrid(items: game.cards, aspectRatio: 5/8) { card in
            if isDealt(card) && (card.isFaceUp || !card.isMatched) {
                CardView(card: card, colors: game.currentThemeColors)
                    .padding(4)
                    .transition(.asymmetric(insertion: .scale, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            } else {
                Color.clear
            }
        }
        .onAppear {
            dealCards()
        }
    }

    private var bottomMenu: some View {
        HStack {
            Button {
                game.resetGame()
                dealCards()
            } label: {
                Image(systemName: "arrow.clockwise.circle")
            }

            Button {
                withAnimation {
                    game.shuffle()
                }
            } label: {
                Image(systemName: "die.face.5")
            }
        }
        .font(.largeTitle)
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
                Pie(startAngle: DrawingConstants.pieStartAngle, endAngle: DrawingConstants.pieEndAngle)
                    .padding(DrawingConstants.piePadding)
                    .opacity(DrawingConstants.pieOpacity)
                Text(card.content)
                    .rotationEffect(Angle(degrees: card.isMatched ? 360 : 0))
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp, colors: colors)
        }
    }

    /// Returns the scaling factor for the font size to fit in the given `size`.
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) * DrawingConstants.fontScale / DrawingConstants.fontSize
    }

    /// Constants that determine card appearance.
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 1
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        static let piePadding: CGFloat = 5
        static let pieOpacity: CGFloat = 0.5
        static let pieStartAngle = Angle(degrees: 270)
        static let pieEndAngle = Angle(degrees: 30)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
    }
}
