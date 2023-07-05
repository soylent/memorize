//
//  EmojiThemeStore.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import Foundation

/// A model that represents a card theme.
struct MemoryGameTheme<CardContent>: Codable, Identifiable, Equatable where CardContent: Codable & Equatable {
    /// The name of the theme.
    var name: String
    /// Emojis comprising the theme.
    var emojis: [CardContent] {
        willSet {
            if newValue.count < numberOfPairsOfCards {
                numberOfPairsOfCards = newValue.count
            }
        }
    }
    /// Colors to fill the back of each card.
    var rgbaColor: RGBAColor
    /// The number of pairs of cards to show.
    var numberOfPairsOfCards: Int
    /// Unique theme identifier.
    let id: Int

    /// Creates an instance of a theme.
    ///
    /// - Parameter name: the name of the theme.
    /// - Parameter emojis: emojis comprising the theme.
    /// - Parameter color: the color to fill the back of each card.
    /// - Parameter numberOfPairsOfCards: the number of pairs of cards to show. Defaults to the number of emojis.
    fileprivate init(name: String, emojis: [CardContent], color: RGBAColor, id: Int, numberOfPairsOfCards: Int? = nil) {
        self.name = name
        self.emojis = emojis
        self.rgbaColor = color
        self.id = id
        self.numberOfPairsOfCards = min(max(1, numberOfPairsOfCards ?? emojis.count), emojis.count)
    }

    mutating func removeEmoji(_ emoji: CardContent) {
        emojis.removeAll { $0 == emoji }
    }

    mutating func addEmojis(_ emojis: [CardContent]) {
        for emoji in emojis where !self.emojis.contains(emoji) {
            self.emojis.append(emoji)
        }
    }

    mutating func setColor(_ color: RGBAColor) {
        self.rgbaColor = color
    }
}

class EmojiThemeStore: ObservableObject {
    @Published var themes: [MemoryGameTheme<String>] = [] {
        didSet {
            scheduleAutosave()
        }
    }

    private var idCounter = 0
    private var autosaveTimer: Timer?

    init() {
        if let themeData = UserDefaults.standard.data(forKey: AutosaveConstants.storeKey),
           let loadedThemes = try? JSONDecoder().decode([MemoryGameTheme<String>].self, from: themeData) {
            themes = loadedThemes
            idCounter = loadedThemes.map(\.id).max() ?? 0
            print("[~] Loaded \(loadedThemes.count) themes from UserDefaults.")
        } else {
            loadDefaultThemes()
        }
    }

    private func loadDefaultThemes() {
        appendTheme(name: "Animals", emojis: [
            "🐡", "🐧", "🦉", "🐥", "🦆", "🙊", "🐷", "🦊", "🐻", "🐝", "🐴", "🐢", "🐙", "🐻‍❄️", "🐗", "🐨",
        ], color: .greenColor, numberOfPairsOfCards: 7)
        appendTheme(name: "Food", emojis: [
            "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"], color: .redColor, numberOfPairsOfCards: 5)
        appendTheme(name: "Vehicles", emojis: [
            "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🚚", "🚛", "🚜", "🚲", "🛵", "🚁"], color: .blueColor)
        appendTheme(name: "Sports", emojis: [
            "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸", "⛳️", "🪃", "🥊", "⛸", "🛷"], color: .mintColor)
        appendTheme(name: "Smileys", emojis: [
            "😀", "😁", "🥹", "😇", "🥳", "😜", "🤩", "🥸", "😐", "😬", "😓", "🙄", "🤔", "😱", "🧐", "🤫"], color: .orangeColor, numberOfPairsOfCards: 8)
        appendTheme(name: "Flags", emojis: [
            "🇦🇷", "🇦🇲", "🇧🇭", "🇨🇲", "🇨🇫", "🇨🇦", "🇦🇴", "🇪🇺", "🇮🇸", "🇯🇵", "🇱🇹", "🇳🇬", "🇰🇷", "🇨🇭", "🇹🇷", "🇫🇮"], color: .tealColor, numberOfPairsOfCards: 6)
    }

    @discardableResult
    func appendTheme(name: String = "", emojis: [String] = [], color: RGBAColor = .blueColor, numberOfPairsOfCards: Int = 6) -> MemoryGameTheme<String> {
        idCounter += 1
        let newTheme = MemoryGameTheme(name: name, emojis: emojis, color: color, id: idCounter, numberOfPairsOfCards: numberOfPairsOfCards)
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
