//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by user on 5/21/23.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let themes = [
        MemoryGameTheme<String>(name: "Animals", emojis: [
            "🐡", "🐧", "🦉", "🐥", "🦆", "🙊", "🐷", "🦊", "🐻", "🐝", "🐴", "🐢", "🐙", "🐻‍❄️", "🐗", "🐨"
        ], numberOfPairsOfCards: 7, color: "green"),
        MemoryGameTheme<String>(name: "Food", emojis: [
            "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"], numberOfPairsOfCards: 5, color: "orange"),
        MemoryGameTheme<String>(name: "Vehicles", emojis: [
            "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🛻", "🚚", "🚛", "🚜", "🏍", "🚝", "🚲", "🛵", "🛴", "🚁"], numberOfPairsOfCards: 8, color: "blue"),
    ]

    @Published private var model: MemoryGame<String>!
    @Published private var currentTheme: MemoryGameTheme<String>!

    private static func makeMemoryGame(_ theme: MemoryGameTheme<String>) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { pairIndex in
            theme.emojis[pairIndex]
        }
    }

    init() {
        resetGame()
    }

    func resetGame() {
        let randomTheme = EmojiMemoryGame.themes.randomElement()!
        currentTheme = randomTheme
        model = EmojiMemoryGame.makeMemoryGame(currentTheme)
    }

    var cards: [MemoryGame<String>.Card] {
        model.cards
    }

    var currentThemeName: String {
        currentTheme.name
    }

    var currentThemeColor: Color {
        Color(currentTheme.color)
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
