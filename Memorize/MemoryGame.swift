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
    private(set) var cards: [Card]
    /// The time of the last successful card match.
    private var timeOfLastMatch: Date = .init()
    /// Player's score.
    private(set) var currentScore = 0
    /// Indices of the cards that the player has already seen.
    private var seenCardIndices = Set<Int>()
    /// The index of the one card that is face up.
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue } }
    }

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
        cards = []
        for pairIndex in 0 ..< numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }

        shuffle()
    }

    func cardIndex(for card: Card) -> Int? {
        cards.firstIndex { $0.id == card.id }
    }

    /// Updates the game state when the playes chooses the given `card`.
    mutating func choose(_ card: Card) {
        guard let chosenIndex = cardIndex(for: card),
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
            cards[chosenIndex].isFaceUp = true
            seenCardIndices.insert(chosenIndex)
            seenCardIndices.insert(potentialMatchIndex)
        } else {
            indexOfTheOneAndOnlyFaceUpCard = chosenIndex
        }
    }

    /// Shuffles the cards.
    mutating func shuffle() {
        cards.shuffle()
    }

    /// A model that represents a single card.
    struct Card: Identifiable {
        /// Whether or not the card is face up.
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }

        /// Whether or not the card has been matched.
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }

        /// The face of the card.
        let content: CardContent
        /// A unique card identifier.
        let id: Int

        /// The time limit to get a bonus.
        let bonusTimeLimit: TimeInterval = 6
        /// The last time this card was turned face up and is still face up.
        var lastFaceUpDate: Date?
        /// The accumated time this card has been face up in the past.
        var pastFaceUpTime: TimeInterval = 0

        /// How much time left before the bonus opportunity runs out.
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }

        /// Percentage of the bonus time remaining.
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }

        /// Whether the card was matched during the bonus time period.
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }

        /// Whether we are currently face up, unmatched and have not yet used up the bonus window.
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }

        /// Returns the total time this card has ever been face up.
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }

        /// Called when the card transitions to face up state.
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }

        /// Called when the card goes back face down or gets matched.
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            lastFaceUpDate = nil
        }
    }
}

extension Array {
    /// Returns the only element stored in a single element array; otherwise returns nil.
    var oneAndOnly: Element? {
        count == 1 ? first : nil
    }
}
