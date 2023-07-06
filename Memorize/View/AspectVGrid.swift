//
//  AspectVGrid.swift
//  Memorize
//
//  Created by user on 6/2/23.
//

import SwiftUI

/// Similar to LazyVGrid, but adjusts the size of each item to fit the available space.
struct AspectVGrid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    /// Items to display.
    var items: [Item]

    /// The desired aspect ratio of each item.
    var aspectRatio: CGFloat

    /// Returns a view that represents the given item.
    var content: (Item) -> ItemView

    /// Creates a new grid instance with the given parameters.
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    /// The body of the view.
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }

    /// Returns an instance of `GridItem` with the given `width`.
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }

    /// Returns the item width to fit `itemCount` items with `itemAspectRatio`
    /// in the space of the given `size`.
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
        } while columnCount < itemCount
        if columnCount > itemCount {
            columnCount = itemCount
        }
        return floor(size.width / CGFloat(columnCount))
    }
}
