//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by user on 5/30/23.
//

import Foundation

/// A model that represents a card theme.
struct MemoryGameTheme<CardContent>: Codable, Identifiable, Equatable where CardContent: Codable, CardContent: Equatable {
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
    var colors: [String]
    /// The number of pairs of cards to show.
    var numberOfPairsOfCards: Int
    /// Unique theme identifier.
    let id: Int

    /// Creates an instance of a theme.
    ///
    /// - Parameter name: the name of the theme.
    /// - Parameter emojis: emojis comprising the theme.
    /// - Parameter colors: colors to fill the back of each card.
    /// - Parameter numberOfPairsOfCards: the number of pairs of cards to show. Defaults to the number of emojis.
    /// - Parameter randomizeNumberOfPairsOfCards: if true, `numberOfPairsOfCards` is set to a random
    ///   number between 1 and `numberOfPairsOfCards`.
    init(name: String, emojis: [CardContent], colors: String..., numberOfPairsOfCards: Int? = nil, randomizeNumberOfPairsOfCards: Bool = false) {
        self.name = name
        self.emojis = emojis
        self.colors = colors
        var clampedNumberOfPairsOfCards = min(max(1, numberOfPairsOfCards ?? emojis.count), emojis.count)
        if randomizeNumberOfPairsOfCards {
            clampedNumberOfPairsOfCards = Int.random(in: 1 ... clampedNumberOfPairsOfCards)
        }
        self.numberOfPairsOfCards = clampedNumberOfPairsOfCards
        idCounter += 1
        self.id = idCounter
    }

    mutating func removeEmoji(_ emoji: CardContent) {
        emojis.removeAll { $0 == emoji }
    }

    mutating func addEmojis(_ emojis: [CardContent]) {
        for emoji in emojis {
            if !self.emojis.contains(emoji) {
                self.emojis.append(emoji)
            }
        }
    }

    mutating func setColor(_ color: String) {
        colors = [color]
    }
}

private var idCounter = 0
