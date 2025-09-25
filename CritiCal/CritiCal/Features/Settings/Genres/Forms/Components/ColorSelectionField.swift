//
//  ColorSelectionField.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalDomain
import CritiCalExtensions
import CritiCalUI
import SwiftUI

struct ColorSelectionField: View {
    @Binding var selection: ColorToken
    var columns: [GridItem]

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(ColorToken.allCases) { token in
                ColorCell(
                    color: token.color,
                    selected: token == selection
                ) { selection = token }
                    .id(token)
                    .accessibilityLabel(Text(token.rawValue.capitalized))
            }
        }
    }
}

extension ColorToken {
    var color: Color {
        Color(hex: rawValue)
    }
}
