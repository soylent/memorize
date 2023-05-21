//
//  ContentView.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

struct ContentView: View {
    private static let animalEmojis = [
        "🐡", "🐧", "🦉", "🐥", "🦆", "🙊", "🐷", "🦊", "🐻", "🐝", "🐴", "🐢", "🐙", "🐻‍❄️", "🐗", "🐨"
    ]
    private static let foodEmojis = [
        "🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒", "🌭"
    ]
    private static let transportEmojis = [
        "🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🛻", "🚚", "🚛", "🚜", "🏍", "🚝", "🚲", "🛵", "🛴", "🚁"
    ]
    
    @State private var emojis = animalEmojis
    @State private var emojiCount = 10
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: widthThatBestFits(cardCount: emojiCount)))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }}
            .foregroundColor(.secondary)
            Spacer()
            HStack(alignment: .bottom) {
                animalTheme
                foodTheme
                vehicleTheme
            }
            .padding(.horizontal)
            .font(.largeTitle)
        }
        .padding(.horizontal)
    }
    
    private var animalTheme: some View {
        Button {
            switchTheme(to: ContentView.animalEmojis)
        } label: {
            VStack {
                Image(systemName: "pawprint")
                Text("Animals").font(.body)
            }
        }
    }
    
    private var foodTheme: some View {
        Button {
            switchTheme(to: ContentView.foodEmojis)
        } label: {
            VStack {
                Image(systemName: "takeoutbag.and.cup.and.straw")
                Text("Food").font(.body)
            }
        }
    }

    private var vehicleTheme: some View {
        Button {
            switchTheme(to: ContentView.transportEmojis)
        } label: {
            VStack {
                Image(systemName: "car")
                Text("Vehicles").font(.body)
            }
        }
    }
    
    private func switchTheme(to newEmojis: [String]) {
        emojiCount = Int.random(in: 4...15)
        emojis = newEmojis.shuffled()
    }
    
    private func widthThatBestFits(cardCount: Int) -> CGFloat {
        330.0 / CGFloat(cardCount).squareRoot().rounded(.up)
    }
}

struct CardView: View {
    var content: String
    @State var isFaceUp = true

    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 24)
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill()
            }
        }
        .onTapGesture {
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
