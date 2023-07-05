//
//  RGBAColor.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import SwiftUI

struct RGBAColor: Codable, Equatable, Hashable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}

extension Color {
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBAColor {
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }

    static var redColor: RGBAColor { Self(color: Color.red) }
    static var blueColor: RGBAColor { Self(color: Color.blue) }
    static var greenColor: RGBAColor { Self(color: Color.green) }
    static var mintColor: RGBAColor { Self(color: Color.mint) }
    static var tealColor: RGBAColor { Self(color: Color.teal) }
    static var orangeColor: RGBAColor { Self(color: Color.orange) }
}

extension MemoryGameTheme {
    var color: Color {
        get {
            Color(rgbaColor: rgbaColor)
        }
        set {
            rgbaColor = RGBAColor(color: newValue)
        }
    }
}
