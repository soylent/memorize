//
//  MemorizeApp.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

/// The memorize app.
@main
struct MemorizeApp: App {
    /// Instance of the theme store view model.
    @StateObject private var themeStore = EmojiThemeStore()

    var body: some Scene {
        WindowGroup {
            EmojiThemeChooser(themeStore: themeStore)
        }
    }
}
