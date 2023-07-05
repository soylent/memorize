//
//  EmojiThemeChooser.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import SwiftUI

struct EmojiThemeChooser: View {
    @ObservedObject var themeStore: EmojiThemeStore

    @State private var games: [Int: EmojiMemoryGame]
    @State private var editMode: EditMode = .inactive
    @State private var themeToEdit: MemoryGameTheme<String>?

    init(themeStore: EmojiThemeStore) {
        self.themeStore = themeStore
        var games = [Int: EmojiMemoryGame]()
        for theme in themeStore.themes {
            games[theme.id] = EmojiMemoryGame(theme: theme)
        }
        _games = .init(initialValue: games)
    }

    var body: some View {
        VStack(alignment: .trailing) {
            NavigationView {
                List {
                    ForEach(themeStore.themes) { theme in
                        NavigationLink {
                            EmojiMemoryGameView(game: games[theme.id]!)
                        } label: { label(for: theme) }
                            .onChange(of: theme) { theme in
                                games[theme.id]?.resetGame(usingTheme: theme)
                            }
                    }
                    .onDelete { indexSet in
                        for themeIndex in indexSet {
                            games.removeValue(forKey: themeStore.themes[themeIndex].id)
                        }
                        themeStore.themes.remove(atOffsets: indexSet)
                    }
                    .onMove { oldIndexSet, newIndexSet in
                        themeStore.themes.move(fromOffsets: oldIndexSet, toOffset: newIndexSet)
                    }
                }
                .navigationTitle("Memorize")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    EditButton()
                }
                .environment(\.editMode, $editMode)
            }
            HStack {
                Button {
                    let newTheme = themeStore.appendTheme()
                    games[newTheme.id] = EmojiMemoryGame(theme: newTheme)
                    themeToEdit = newTheme
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .font(.title)
            .padding()
        }
    }

    private func label(for theme: MemoryGameTheme<String>) -> some View {
        let tapToEdit = TapGesture().onEnded {
            themeToEdit = theme
        }
        return HStack {
            Circle()
                .fill(theme.color)
                .frame(width: 10)
            Text(theme.name)
            Spacer()
            Text("\(theme.numberOfPairsOfCards)/\(theme.emojis.count)")
            Divider()
            let emojiPreviewCount = min(3, theme.emojis.count)
            Text(theme.emojis[..<emojiPreviewCount].joined())
        }
        .sheet(item: $themeToEdit) { theme in
            if let themeIndex = themeStore.themes.firstIndex { $0.id == theme.id } {
                EmojiThemeEditor(theme: $themeStore.themes[themeIndex])
            }
        }
        .gesture(editMode == .active ? tapToEdit : nil)
    }
}

struct EmojiThemeChooser_Previews: PreviewProvider {
    static var previews: some View {
        let themeStore = EmojiThemeStore()
        EmojiThemeChooser(themeStore: themeStore)
    }
}
