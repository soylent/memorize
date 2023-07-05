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
    @State private var themeToAdd: MemoryGameTheme<String>?

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
                    ToolbarItem { EditButton() }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            themeToAdd = themeStore.newTheme()
                        } label: {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                .environment(\.editMode, $editMode)
                .sheet(item: $themeToAdd) { theme in
                    let themeBinding = Binding(get: { theme }, set: { themeToAdd = $0 })
                    EmojiThemeEditor(theme: themeBinding)
                        .onDisappear {
                            if theme.isValid {
                                games[theme.id] = EmojiMemoryGame(theme: theme)
                                withAnimation {
                                    themeStore.themes.append(theme)
                                }
                            }
                        }
                }
                .sheet(item: $themeToEdit) { theme in
                    if let themeIndex = themeStore.themes.firstIndex { $0.id == theme.id } {
                        EmojiThemeEditor(theme: $themeStore.themes[themeIndex])
                    }
                }
            }
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
            Text(theme.emojis[..<theme.currentMinNumberOfPairsOfCards].joined())
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
