//
//  Pie.swift
//  Memorize
//
//  Created by soylent on 6/3/23.
//

import SwiftUI

/// Circle with a cut starting at `startAngle` and ending at `endAngle`.
struct Pie: Shape {
    /// The start angle of the cut.
    var startAngle: Angle

    /// The end angle of the cut.
    var endAngle: Angle

    /// The cut direction.
    var clockwise = true

    var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(startAngle.radians, endAngle.radians)
        }
        set {
            startAngle = Angle.radians(newValue.first)
            endAngle = Angle.radians(newValue.second)
        }
    }

    /// Returns the pie shape.
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let top = CGPoint(
            x: center.x + radius * CGFloat(cos(startAngle.radians)),
            y: center.y + radius * CGFloat(sin(startAngle.radians))
        )
        var path = Path()
        path.move(to: center)
        path.addLine(to: top)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        path.addLine(to: center)
        return path
    }
}
