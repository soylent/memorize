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
        didSet {
            if emojis.count <= minNumberOfPairsOfCards || emojis.count < numberOfPairsOfCards {
                numberOfPairsOfCards = emojis.count
            }
        }
    }

    /// Colors to fill the back of each card.
    var rgbaColor: RGBAColor
    /// The number of pairs of cards to show.
    var numberOfPairsOfCards: Int
    /// Unique theme identifier.
    let id: Int
    var currentMinNumberOfPairsOfCards: Int { min(2, emojis.count) }
    /// The minimum number of pairs of cards.
    private var minNumberOfPairsOfCards: Int { 2 }

    /// Creates an instance of a theme.
    ///
    /// - Parameter name: the name of the theme.
    /// - Parameter emojis: emojis comprising the theme.
    /// - Parameter color: the color to fill the back of each card.
    /// - Parameter numberOfPairsOfCards: the number of pairs of cards to show. Defaults to the number of emojis.
    fileprivate init(name: String, emojis: [CardContent], color: RGBAColor, id: Int, numberOfPairsOfCards: Int? = nil) {
        self.name = name
        self.emojis = emojis
        rgbaColor = color
        self.id = id
        self.numberOfPairsOfCards = min(max(1, numberOfPairsOfCards ?? emojis.count), emojis.count)
    }

    var isValid: Bool {
        !name.isEmpty && emojis.count >= minNumberOfPairsOfCards
    }

    mutating func removeEmoji(_ emoji: CardContent) {
        if emojis.count > minNumberOfPairsOfCards {
            emojis.removeAll { $0 == emoji }
        }
    }

    mutating func addEmojis(_ emojis: [CardContent]) {
        for emoji in emojis where !self.emojis.contains(emoji) {
            self.emojis.append(emoji)
        }
    }

    mutating func setColor(_ color: RGBAColor) {
        rgbaColor = color
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
           let loadedThemes = try? JSONDecoder().decode([MemoryGameTheme<String>].self, from: themeData)
        {
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
        ], color: .greenColor, numberOfPairsOfCards: 10)
        appendTheme(name: "Food", emojis: [
            "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"], color: .redColor, numberOfPairsOfCards: 10)
        appendTheme(name: "Vehicles", emojis: [
            "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🚚", "🚛", "🚜", "🚲", "🛵", "🚁"], color: .blueColor, numberOfPairsOfCards: 6)
        appendTheme(name: "Sports", emojis: [
            "⚽️", "🏀", "🏈", "⚾️", "🥎", "🏐", "🏉", "🥏", "🎱", "🏓", "🏸", "⛳️", "🪃", "🥊", "⛸", "🛷"], color: .mintColor, numberOfPairsOfCards: 6)
        appendTheme(name: "Smileys", emojis: [
            "😀", "😁", "🥹", "😇", "🥳", "😜", "🤩", "🥸", "😐", "😬", "😓", "🙄", "🤔", "😱", "🧐", "🤫"], color: .orangeColor, numberOfPairsOfCards: 4)
        appendTheme(name: "Flags", emojis: [
            "🇦🇷", "🇦🇲", "🇧🇭", "🇨🇲", "🇨🇫", "🇨🇦", "🇦🇴", "🇪🇺", "🇮🇸", "🇯🇵", "🇱🇹", "🇳🇬", "🇰🇷", "🇨🇭", "🇹🇷", "🇫🇮"], color: .tealColor, numberOfPairsOfCards: 6)
    }

    func newTheme(name: String = "", emojis: [String] = [], color: RGBAColor = .blueColor, numberOfPairsOfCards: Int = 0) -> MemoryGameTheme<String> {
        idCounter += 1
        return MemoryGameTheme(name: name, emojis: emojis, color: color, id: idCounter, numberOfPairsOfCards: numberOfPairsOfCards)
    }

    private func appendTheme(name: String, emojis: [String], color: RGBAColor, numberOfPairsOfCards: Int) {
        themes.append(newTheme(name: name, emojis: emojis, color: color, numberOfPairsOfCards: numberOfPairsOfCards))
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
