//
//  ContentView.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

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

struct CardView: View {
    let card: MemoryGame<String>.Card
    let colors: [Color]

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
