//
//  MemorizeApp.swift
//  Memorize
//
//  Created by user on 4/11/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
