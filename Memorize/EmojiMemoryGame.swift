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

    /// All available themes.
    private static let themes = [
        MemoryGameTheme(name: "Animals", emojis: [
            "🐡", "🐧", "🦉", "🐥", "🦆", "🙊", "🐷", "🦊", "🐻", "🐝", "🐴", "🐢", "🐙", "🐻‍❄️", "🐗", "🐨",
        ], colors: "green", numberOfPairsOfCards: 7),
        MemoryGameTheme(name: "Food", emojis: [
            "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"], colors: "orange", numberOfPairsOfCards: 5),
        MemoryGameTheme(name: "Vehicles", emojis: [
            "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🚚", "🚛", "🚜", "🚲", "🛵", "🚁"], colors: "teal", "blue"),
        MemoryGameTheme(name: "Sports", emojis: [
            "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸", "⛳️", "🪃", "🥊", "⛸", "🛷"], colors: "mint", "green", randomizeNumberOfPairsOfCards: true),
        MemoryGameTheme(name: "Smileys", emojis: [
            "😀", "😁", "🥹", "😇", "🥳", "😜", "🤩", "🥸", "😐", "😬", "😓", "🙄", "🤔", "😱", "🧐", "🤫"], colors: "orange", "red", numberOfPairsOfCards: 8, randomizeNumberOfPairsOfCards: true),
        MemoryGameTheme(name: "Flags", emojis: [
            "🇦🇷", "🇦🇲", "🇧🇭", "🇨🇲", "🇨🇫", "🇨🇦", "🇦🇴", "🇪🇺", "🇮🇸", "🇯🇵", "🇱🇹", "🇳🇬", "🇰🇷", "🇨🇭", "🇹🇷", "🇫🇮"], colors: "yellow", numberOfPairsOfCards: 6),
    ]

    /// An instance of the game model.
    @Published private var model: MemoryGame<String>!
    /// An instance of the current theme.
    private var theme: MemoryGameTheme<String>!

    /// Returns an instance of the game model based on the given `theme`.
    private static func makeMemoryGame(_ theme: MemoryGameTheme<String>) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { emojis[$0] }
    }

    /// Creates an instance of the view model.
    init() {
        resetGame()
    }

    /// Starts a new game.
    func resetGame() {
        let randomTheme = EmojiMemoryGame.themes.randomElement()!
        theme = randomTheme
        model = EmojiMemoryGame.makeMemoryGame(theme)
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
    var currentThemeColors: [Color] {
        theme.colors.map { color in
            var mappedColor = Color.black
            switch color {
            case "blue":
                mappedColor = Color.blue
            case "brown":
                mappedColor = Color.brown
            case "green":
                mappedColor = Color.green
            case "orange":
                mappedColor = Color.orange
            case "red":
                mappedColor = Color.red
            case "yellow":
                mappedColor = Color.yellow
            case "gray":
                mappedColor = Color.gray
            case "cyan":
                mappedColor = Color.cyan
            case "teal":
                mappedColor = Color.teal
            case "mint":
                mappedColor = Color.mint
            default:
                break
            }
            return mappedColor
        }
    }

    /// The player's score.
    var currentScore: Int {
        model.currentScore
    }

    func cardIndex(for card: Card) -> Int? {
        model.cardIndex(for: card)
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
