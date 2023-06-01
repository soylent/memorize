//
//  ContentView.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

/// The main view of the app.
struct ContentView: View {
    /// A reference to the view model.
    @ObservedObject var viewModel: EmojiMemoryGame
    /// The body of the view.
    var body: some View {
        VStack {
            Text(viewModel.currentThemeName).font(.largeTitle)
            Text("Score: \(viewModel.currentScore)")
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, colors: viewModel.currentThemeColors).aspectRatio(2/3, contentMode: .fit).onTapGesture {
                            viewModel.choose(card)
                        }
                    }
                }}
            .padding(.horizontal)
            Button {
                viewModel.resetGame()
            } label: {
                Image(systemName: "arrow.clockwise.circle").font(.largeTitle)
            }
        }
    }
}

/// A view that represents a single card.
struct CardView: View {
    /// The card model.
    let card: MemoryGame<String>.Card
    /// Colors to fill the back of the card.
    let colors: [Color]
    /// The body of the view.
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 24)
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill(Gradient(colors: colors))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
    }
}
