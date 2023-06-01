//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by user on 5/30/23.
//

import Foundation

/// A model that represents a card theme.
struct MemoryGameTheme<CardContent> {
    /// The name of the theme.
    let name: String
    /// Emojis comprising the theme.
    let emojis: [CardContent]
    /// Colors to fill the back of each card.
    let colors: [String]
    /// The number of pairs of cards to show.
    let numberOfPairsOfCards: Int

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
        var _numberOfPairsOfCards = min(max(1, numberOfPairsOfCards ?? emojis.count), emojis.count)
        if randomizeNumberOfPairsOfCards {
            _numberOfPairsOfCards = Int.random(in: 1..._numberOfPairsOfCards)
        }
        self.numberOfPairsOfCards = _numberOfPairsOfCards
    }
}
