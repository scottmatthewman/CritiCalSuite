//
//  ColorTokenField.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalModels
import CritiCalExtensions
import SwiftUI

public struct ColorTokenField: View {
    @Binding private var selection: ColorToken

    private var tokens: [ColorToken]
    private var columns: [GridItem]

    public init(
        selection: Binding<ColorToken>,
        tokens: [ColorToken] = ColorToken.allCases,
        columns: [GridItem]
    ) {
        self._selection = selection
        self.tokens = tokens
        self.columns = columns
    }

    public var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(tokens) { token in
                ColorCell(
                    color: token.color,
                    isSelected: token == selection
                ) {
                    selection = token
                }
                .id(token)
                .accessibilityLabel(Text(token.description))
            }
        }
    }
}
