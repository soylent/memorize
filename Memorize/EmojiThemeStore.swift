//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import Foundation

class EmojiThemeStore: ObservableObject {
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

    @Published var themes: [MemoryGameTheme<String>]

    init() {
        if let themeData = UserDefaults.standard.data(forKey: "memorize.themes"),
           let loadedThemes = try? JSONDecoder().decode([MemoryGameTheme<String>].self, from: themeData) {
            themes = loadedThemes
            print("Loaded \(loadedThemes.count) from UserDefaults")
        } else {
            themes = Self.themes
        }
    }
}
