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

    @Published var themes: [MemoryGameTheme<String>] {
        didSet {
            scheduleAutosave()
        }
    }

    private var autosaveTimer: Timer?

    init() {
        if let themeData = UserDefaults.standard.data(forKey: AutosaveConstants.storeKey),
           let loadedThemes = try? JSONDecoder().decode([MemoryGameTheme<String>].self, from: themeData) {
            themes = loadedThemes
            print("[~] Loaded \(loadedThemes.count) themes from UserDefaults.")
        } else {
            themes = Self.defaultThemes
        }
    }

    func appendTheme(name: String = "", emojis: [String] = [], color: String = "blue", numberOfPairsOfCards: Int = 6) -> MemoryGameTheme<String> {
        let newTheme = MemoryGameTheme(name: name, emojis: emojis, colors: color, numberOfPairsOfCards: numberOfPairsOfCards)
        themes.append(newTheme)
        return newTheme
    }

    private func scheduleAutosave() {
        autosaveTimer?.invalidate()
        autosaveTimer = Timer.scheduledTimer(withTimeInterval: AutosaveConstants.coalescingInterval, repeats: false) { _ in
            self.save()
        }
    }

    private func save() {
        if let themeData = try? JSONEncoder().encode(themes) {
            UserDefaults.standard.set(themeData, forKey: AutosaveConstants.storeKey)
            print("[~] Autosaved \(themes.count) themes to UserDefaults.")
        }
    }

    private enum AutosaveConstants {
        static let storeKey = "memorize.themes"
        static let coalescingInterval = 5.0
    }
}
