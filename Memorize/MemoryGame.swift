//
//  MemoryGame.swift
//  Memorize
//
//  Created by user on 5/21/23.
//

import Foundation

/// A model for the game logic.
struct MemoryGame<CardContent> where CardContent: Equatable {
    /// All available cards.
    private(set) var cards: Array<Card>
    /// The index of the one card that is face up.
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    /// The time of the last successful card match.
    private var timeOfLastMatch: Date = Date()
    /// Player's score.
    private(set) var currentScore = 0
    /// Indices of the cards that the player has already seen.
    private var seenCardIndices = Set<Int>()

    /// The number of points the player receives for a successful match.
    private var matchPoints: Int {
        max(10 + Int(timeOfLastMatch.timeIntervalSinceNow), 1) * 2
    }
    /// The number of points for a mismatch.
    private let mismatchPoints = -1

    /// Creates an instance of the game by calling the `createCardContent` closure `numberOfPairsOfCards`
    /// times to generate an array of cards.
    ///
    /// - Parameter numberOfPairsOfCards: the number of pairs of cards to show.
    /// - Parameter createCardContent: a closure that is called to get the face of each card.
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards = cards.shuffled()
    }

    /// Updates the game state when the playes chooses the given `card`.
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else { return }

        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true

                currentScore += matchPoints
                timeOfLastMatch = Date()
            } else if seenCardIndices.contains(chosenIndex) || seenCardIndices.contains(potentialMatchIndex) {
                currentScore += mismatchPoints
            }
            indexOfTheOneAndOnlyFaceUpCard = nil
            seenCardIndices.insert(chosenIndex)
            seenCardIndices.insert(potentialMatchIndex)
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
            indexOfTheOneAndOnlyFaceUpCard = chosenIndex
        }
        cards[chosenIndex].isFaceUp.toggle()
    }

    /// A model that represents a single card.
    struct Card: Identifiable {
        /// Whether or not the card is face up.
        var isFaceUp: Bool = false
        /// Whether or not the card has been matched.
        var isMatched: Bool = false
        /// The face of the card.
        var content: CardContent
        /// A unique card identifier.
        var id: Int
    }
}
