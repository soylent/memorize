//
//  EmojiThemeChooser.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import SwiftUI

struct EmojiThemeChooser: View {
    @ObservedObject var themeStore: EmojiThemeStore

    var body: some View {
        // NOTE: Due to a bug in SwiftUI, animations are not working in NavigationStack.
        // https://developer.apple.com/forums/thread/728132
        NavigationStack {
            List {
                ForEach(themeStore.themes) { theme in
                    NavigationLink {
                        EmojiThemeEditor(theme: $themeStore.themes[themeStore.themes.firstIndex { $0.id == theme.id }!])
                    } label: { label(for: theme) }
                }
            }
            .navigationTitle("Memorize")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func label(for theme: MemoryGameTheme<String>) -> some View {
            HStack {
                Circle()
                    .fill(Gradient(colors: themeColors(for: theme)))
                    .frame(width: 10)
                Text(theme.name)
                Spacer()
                Text(theme.emojis[..<3].joined())
            }
    }

    /// Returns the colors associated with the given `theme`.
    private func themeColors(for theme: MemoryGameTheme<String>) -> [Color] {
        theme.colors.map { color in
            var mappedColor = Color.black
            switch color {
            case "blue":
                mappedColor = Color.blue
            case "brown":
                mappedColor = Color.brown
            case "green":
                mappedColor = Color.green
            case "orange":
                mappedColor = Color.orange
            case "red":
                mappedColor = Color.red
            case "yellow":
                mappedColor = Color.yellow
            case "gray":
                mappedColor = Color.gray
            case "cyan":
                mappedColor = Color.cyan
            case "teal":
                mappedColor = Color.teal
            case "mint":
                mappedColor = Color.mint
            default:
                break
            }
            return mappedColor
        }
    }
}

struct EmojiThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = EmojiThemeStore()
        EmojiThemeChooser(themeStore: themeStore)
    }
}
