//
//  RGBAColor.swift
//  Memorize
//
//  Created by user on 6/28/23.
//

import SwiftUI

/// Serializable representation of a color.
struct RGBAColor: Codable, Equatable, Hashable {
    /// The red component of the color.
    let red: Double

    /// The green component of the color.
    let green: Double

    /// The blue component of the color.
    let blue: Double

    /// The alpha component of the color.
    let alpha: Double
}

extension Color {
    /// Converts the given `rbgaColor` color to `Color`.
    init(rgbaColor rgba: RGBAColor) {
        self.init(.sRGB, red: rgba.red, green: rgba.green, blue: rgba.blue, opacity: rgba.alpha)
    }
}

extension RGBAColor {
    /// Converts the given `color` to `RGBAColor`.
    init(color: Color) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        UIColor(color).getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: Double(red), green: Double(green), blue: Double(blue), alpha: Double(alpha))
    }

    /// The RGBA representation of `Color.red`.
    static var redColor: RGBAColor { Self(color: Color.red) }

    /// The RGBA representation of `Color.blue`.
    static var blueColor: RGBAColor { Self(color: Color.blue) }

    /// The RGBA representation of `Color.green`.
    static var greenColor: RGBAColor { Self(color: Color.green) }

    /// The RGBA representation of `Color.mint`.
    static var mintColor: RGBAColor { Self(color: Color.mint) }

    /// The RGBA representation of `Color.teal`.
    static var tealColor: RGBAColor { Self(color: Color.teal) }

    /// The RGBA representation of `Color.orange`.
    static var orangeColor: RGBAColor { Self(color: Color.orange) }
}

extension MemoryGameTheme {
    /// The theme color.
    var color: Color {
        get {
            Color(rgbaColor: rgbaColor)
        }
        set {
            rgbaColor = RGBAColor(color: newValue)
        }
    }
}
