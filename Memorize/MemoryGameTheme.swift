//
//  EmojiMemoryGameTheme.swift
//  Memorize
//
//  Created by user on 5/30/23.
//

import Foundation

struct MemoryGameTheme<CardContent> {
    let name: String
    let emojis: [CardContent]
    let numberOfPairsOfCards: Int
    let colors: [String]

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
