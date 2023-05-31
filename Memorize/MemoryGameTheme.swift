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
    let color: String

    init(name: String, emojis: [CardContent], numberOfPairsOfCards: Int, color: String) {
        self.name = name
        self.emojis = emojis
        self.numberOfPairsOfCards = min(max(0, numberOfPairsOfCards), emojis.count)
        self.color = color
    }
}
