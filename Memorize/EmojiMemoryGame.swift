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
        ], colors: "green", numberOfPairsOfCards: 7),
        MemoryGameTheme<String>(name: "Food", emojis: [
            "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"], colors: "orange", numberOfPairsOfCards: 5),
        MemoryGameTheme<String>(name: "Vehicles", emojis: [
            "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🚚", "🚛", "🚜", "🚲", "🛵", "🚁"], colors: "teal", "blue"),
        MemoryGameTheme<String>(name: "Sports", emojis: [
            "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸", "⛳️", "🪃", "🥊", "⛸", "🛷"], colors: "mint", "green", randomizeNumberOfPairsOfCards: true),
        MemoryGameTheme<String>(name: "Smileys", emojis: [
            "😀", "😁", "🥹", "😇", "🥳", "😜", "🤩", "🥸", "😐", "😬", "😓", "🙄", "🤔", "😱", "🧐", "🧐"], colors: "orange", "red", numberOfPairsOfCards: 8, randomizeNumberOfPairsOfCards: true),
        MemoryGameTheme<String>(name: "Flags", emojis: [
            "🇦🇷", "🇦🇲", "🇧🇭", "🇨🇲", "🇨🇫", "🇨🇦", "🇦🇴", "🇪🇺", "🇮🇸", "🇯🇵", "🇱🇹", "🇳🇬", "🇰🇷", "🇨🇭", "🇹🇷", "🇫🇮"], colors: "yellow", numberOfPairsOfCards: 6),
    ]

    @Published private var model: MemoryGame<String>!
    private var currentTheme: MemoryGameTheme<String>!

    private static func makeMemoryGame(_ theme: MemoryGameTheme<String>) -> MemoryGame<String> {
        let emojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairsOfCards) { emojis[$0] }
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

    var currentThemeColors: [Color] {
        currentTheme.colors.map { color in
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

    var currentScore: Int {
        model.currentScore
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
