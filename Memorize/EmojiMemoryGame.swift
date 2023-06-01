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
        MemoryGameTheme<String>(name: "Sports", emojis: [
            "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸", "⛳️", "🪃", "🥊", "⛸", "🛷"], numberOfPairsOfCards: 7, color: "mint"),
        MemoryGameTheme<String>(name: "Smileys", emojis: [
            "😀", "😁", "🥹", "😇", "🥳", "😜", "🤩", "🥸", "😐", "😬", "😓", "🙄", "🤔", "😱", "🧐", "🧐"], numberOfPairsOfCards: 7, color: "red"),
        MemoryGameTheme<String>(name: "Flags", emojis: [
            "🇦🇷", "🇦🇲", "🇧🇭", "🇨🇲", "🇨🇫", "🇨🇦", "🇦🇴", "🇪🇺", "🇮🇸", "🇯🇵", "🇱🇹", "🇳🇬", "🇰🇷", "🇨🇭", "🇹🇷", "🇫🇮"], numberOfPairsOfCards: 7, color: "yellow"),
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

    var currentThemeColor: Color {
        var color = Color.black
        switch currentTheme.color {
        case "blue":
            color = Color.blue
        case "brown":
            color = Color.brown
        case "green":
            color = Color.green
        case "orange":
            color = Color.orange
        case "red":
            color = Color.red
        case "yellow":
            color = Color.yellow
        case "gray":
            color = Color.gray
        case "cyan":
            color = Color.cyan
        case "teal":
            color = Color.teal
        case "mint":
            color = Color.mint
        default:
            break
        }
        return color
    }

    var currentScore: Int {
        model.currentScore
    }

    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
}
