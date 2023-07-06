//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by user on 5/21/23.
//

import SwiftUI

/// The view model.
class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    typealias Theme = MemoryGameTheme<String>

    /// An instance of the game model.
    @Published private var model: MemoryGame<String>!
    @Published private var dealt = Set<Int>()
    /// An instance of the current theme.
    private var theme: Theme!

    /// Returns an instance of the game model based on the given `theme`.
    private static func makeMemoryGame(_ theme: MemoryGameTheme<String>) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { emojis[$0] }
    }

    /// Creates an instance of the view model.
    init(theme: Theme) {
        resetGame(usingTheme: theme)
    }

    /// Starts a new game using the given `theme`.
    func resetGame(usingTheme theme: MemoryGameTheme<String>? = nil) {
        if let theme {
            self.theme = theme
        }
        model = EmojiMemoryGame.makeMemoryGame(theme ?? self.theme)
        dealt.removeAll()
    }

    /// All available cards.
    var cards: [Card] {
        model.cards
    }

    /// The currently selected theme.
    var currentThemeName: String {
        theme.name
    }

    /// The current theme colors that are used to fill the back of each card.
    var currentThemeColor: Color {
        theme.color
    }

    /// The player's score.
    var currentScore: Int {
        model.currentScore
    }

    func cardIndex(for card: Card) -> Int? {
        model.cardIndex(for: card)
    }

    var undealtCards: [EmojiMemoryGame.Card] { cards.filter { !isDealt($0) } }

    func dealCard(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }

    func isDealt(_ card: EmojiMemoryGame.Card) -> Bool {
        dealt.contains(card.id)
    }

    // MARK: - Intent(s)

    /// Chooses the given `card` and updates the game accordingly.
    func choose(_ card: Card) {
        model.choose(card)
    }

    /// Shuffles the cards.
    func shuffle() {
        model.shuffle()
    }
}
