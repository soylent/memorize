//
//  MemoryGame.swift
//  Memorize
//
//  Created by user on 5/21/23.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    private(set) var currentScore = 0
    private var seenCardIndices = Set<Int>()

    private static var matchPoints: Int { 2 }
    private static var mismatchPoints: Int { -1 }

    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2 + 1))
        }
        cards = cards.shuffled()
    }

    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else { return }

        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true

                currentScore += MemoryGame.matchPoints
            } else if seenCardIndices.contains(chosenIndex) || seenCardIndices.contains(potentialMatchIndex) {
                currentScore += MemoryGame.mismatchPoints
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

    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent
        var id: Int
    }
}
