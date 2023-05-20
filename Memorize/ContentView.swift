//
//  ContentView.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

struct ContentView: View {
    static let animals = ["🦑", "🐡", "🐧", "🦉", "🐥", "🦆", "🙊", "🐷", "🦊", "🐻", "🐝", "🐴", "🐢", "🐙", "🐻‍❄️", "🐗"]
    static let food = ["🍎", "🍐", "🥑", "🍋", "🥭", "🌽", "🫐", "🥒", "🍌", "🍉", "🍇", "🥕", "🫑", "🥝", "🫒"]
    static let transport = ["🚗", "🚌", "🏎", "🚓", "🚑", "🚒", "🛻", "🚚", "🚛", "🚜", "🏍", "🚝", "🚲", "🛵", "🛴"]
    @State var emojis = animals
    @State var emojiCount = 15
    
    var body: some View {
        VStack {
            Text("Memorize!").font(.largeTitle)
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji).aspectRatio(2/3, contentMode: .fit)
                    }
                }}
            .foregroundColor(.accentColor)
            Spacer()
            HStack(alignment: .bottom) {
                removeCard
                Spacer()
                Button {
                    emojis = ContentView.animals.shuffled()
                } label: {
                    VStack {
                        Image(systemName: "pawprint")
                        Text("Animals").font(.body)
                    }
                }
                Button {
                    emojis = ContentView.food.shuffled()
                } label: {
                    VStack {
                        Image(systemName: "takeoutbag.and.cup.and.straw")
                        Text("Food").font(.body)
                    }
                }
                Button {
                    emojis = ContentView.transport.shuffled()
                } label: {
                    VStack {
                        Image(systemName: "car")
                        Text("Vehicles").font(.body)
                    }
                }
                Spacer()
                addCard
            }
            .padding(.horizontal)
            .font(.largeTitle)
        }
        .padding(.horizontal)
    }
    
    var removeCard: some View {
        Button {
            if emojiCount > 1 {
                emojiCount -= 1
            }
        } label: {
            Image(systemName: "minus.circle")
        }
    }
    
    var addCard: some View {
        Button {
            if emojiCount < emojis.count {
                emojiCount += 1
            }
        } label: {
            Image(systemName: "plus.circle")
        }
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
