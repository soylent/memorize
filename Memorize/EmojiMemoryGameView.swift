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

    @Namespace private var dealingNamespace

    private var undealtCards: [EmojiMemoryGame.Card] { game.cards.filter { !isDealt($0) } }

    private func dealCards() {
        for card in game.cards {
            _ = withAnimation(dealAnimation(for: card)) {
                dealt.insert(card.id)
            }
        }
    }

    private func isDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        dealt.contains(card.id)
    }

    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let cardIndex = game.cardIndex(for: card) {
            delay = Double(cardIndex) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }

    private func zIndex(for card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cardIndex(for: card) ?? 0)
    }

    /// The body of the view.
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                VStack {
                    Text(game.currentThemeName).font(.largeTitle)
                    Text("Score: \(game.currentScore)")
                    cardGrid
                }
                deckBody
            }
            bottomMenu
        }
        .padding(.horizontal)
    }

    private var cardGrid: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isDealt(card), card.isFaceUp || !card.isMatched {
                CardView(card: card, colors: game.currentThemeColors)
                    .zIndex(zIndex(for: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(CardConstants.padding)
                    .transition(.asymmetric(insertion: .identity, removal: .scale))
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            } else {
                Color.clear
            }
        }
    }

    private var deckBody: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card: card, colors: game.currentThemeColors)
                    .zIndex(zIndex(for: card))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .opacity, removal: .identity))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(game.currentThemeColors.first!)
        .onTapGesture {
            dealCards()
        }
    }

    private var bottomMenu: some View {
        HStack {
            Button {
                withAnimation {
                    dealt.removeAll()
                    game.resetGame()
                }
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

    private enum CardConstants {
        static let aspectRatio: CGFloat = 5 / 9
        static let dealDuration: Double = 0.5
        static let padding: CGFloat = 4
        static let totalDealDuration: Double = 2
        static let undealtWidth: CGFloat = 60
        static let undealtHeight: CGFloat = undealtWidth / aspectRatio
    }
}

/// A view that represents a single card.
struct CardView: View {
    /// The card model.
    let card: EmojiMemoryGame.Card
    /// Colors to fill the back of the card.
    let colors: [Color]

    @State private var animatedBonusRemaining = 0.0

    /// The body of the view.
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: DrawingConstants.pieStartAngle, endAngle: Angle(degrees: (1 - animatedBonusRemaining) * 360 - 90))
                            .onAppear {
                                animatedBonusRemaining = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0.0
                                }
                            }
                    } else {
                        Pie(startAngle: DrawingConstants.pieStartAngle, endAngle: Angle(degrees: (1 - card.bonusRemaining) * 360 - 90))
                    }
                }
                .padding(DrawingConstants.piePadding)
                .opacity(DrawingConstants.pieOpacity)

                Text(card.content)
                    .id(card.content)
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
    private enum DrawingConstants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 1
        static let fontScale: CGFloat = 0.7
        static let fontSize: CGFloat = 32
        static let piePadding: CGFloat = 5
        static let pieOpacity: CGFloat = 0.5
        static let pieStartAngle = Angle(degrees: 270)
    }
}

struct EmojiMemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        return EmojiMemoryGameView(game: game)
    }
}
