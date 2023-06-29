//
//  MemorizeApp.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject private var themeStore = EmojiThemeStore()

    var body: some Scene {
        WindowGroup {
            EmojiThemeChooser(themeStore: themeStore)
        }
    }
}
