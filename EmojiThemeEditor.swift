//
//  EmojiThemeEditor.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import SwiftUI

struct EmojiThemeEditor: View {
    @Binding var theme: MemoryGameTheme<String>

    @State private var emojiToAdd = ""

    private let availableColors: [Color] = [.red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue, .indigo, .purple, .pink, .brown]

    var body: some View {
        Form {
            nameSection
            emojiSection
            addEmojiSection
            cardCountSection
            colorSection
        }
        .navigationTitle(theme.name)
    }

    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
        }
    }

    private var emojiSection: some View {
        Section(header: Text("Emojis")) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 30))]) {
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 30))
                        .onTapGesture {
                            withAnimation {
                                theme.removeEmoji(emoji)
                            }
                        }
                }
            }
        }
    }

    private var addEmojiSection: some View {
        Section(header: Text("Add Emoji")) {
            TextField("Emoji", text: $emojiToAdd)
                .onChange(of: emojiToAdd) { emojis in
                    withAnimation {
                        theme.addEmojis(emojis.map { String($0) })
                    }
                }
        }
    }

    private var cardCountSection: some View {
        Section(header: Text("Card Count")) {
            Stepper(value: $theme.numberOfPairsOfCards, in: theme.currentMinNumberOfPairsOfCards ... theme.emojis.count) {
                Text("\(theme.numberOfPairsOfCards) Pairs")
            }
        }
    }

    private var colorSection: some View {
        Section(header: Text("Color")) {
            ColorPicker("Back color", selection: $theme.color)
        }
    }
}

struct EmojiThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = EmojiThemeStore()
        EmojiThemeEditor(theme: .constant(themeStore.themes[0]))
    }
}
