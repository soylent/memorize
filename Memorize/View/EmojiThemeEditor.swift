//
//  EmojiThemeEditor.swift
//  Memorize
//
//  Created by soylent on 6/28/23.
//

import SwiftUI

/// The theme editing form.
struct EmojiThemeEditor: View {
    /// The theme to edit.
    @Binding var theme: MemoryGameTheme<String>

    /// Emojis to add to the theme.
    @State private var emojiToAdd = ""

    /// The view body.
    var body: some View {
        Form {
            nameSection
            emojiSection
            removedEmojiSection
            addEmojiSection
            cardCountSection
            colorSection
        }
        .navigationTitle(theme.name)
    }

    /// The theme name field.
    private var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: $theme.name)
        }
    }

    /// A grid of the theme emojis.
    private var emojiSection: some View {
        Section(header: Text("Emojis")) {
            emojiGrid(for: theme.emojis) { emoji in theme.removeEmoji(emoji) }
        }
    }

    /// A grid of removed emojis.
    private var removedEmojiSection: some View {
        Section(header: Text("Removed Emojis")) {
            emojiGrid(for: theme.removedEmojis) { emoji in theme.addEmoji(emoji) }
        }
    }

    /// Returns a grid built from the given `emojis` where tapping on each emoji performs `onTapAction`.
    private func emojiGrid(for emojis: [String], onTapAction: @escaping (String) -> Void) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: DrawingConstants.emojiFontSize))]) {
            ForEach(emojis, id: \.self) { emoji in
                Text(emoji)
                    .font(.system(size: DrawingConstants.emojiFontSize))
                    .onTapGesture {
                        withAnimation {
                            onTapAction(emoji)
                        }
                    }
            }
        }
    }

    /// A field to add more emojis to the theme.
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

    /// A control to change the number of pairs of cards.
    private var cardCountSection: some View {
        Section(header: Text("Card Count")) {
            Stepper(value: $theme.numberOfPairsOfCards, in: theme.currentMinNumberOfPairsOfCards ... theme.emojis.count) {
                Text("\(theme.numberOfPairsOfCards) Pairs")
            }
        }
    }

    /// A control to pick the card color.
    private var colorSection: some View {
        Section(header: Text("Color")) {
            ColorPicker("Back color", selection: $theme.color)
        }
    }

    /// Constants that determine the view appearance.
    private enum DrawingConstants {
        static let emojiFontSize: CGFloat = 30
    }
}

struct EmojiThemeEditor_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = EmojiThemeStore()
        EmojiThemeEditor(theme: .constant(themeStore.themes[0]))
    }
}
