//
//  GenreEntity+Color.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI
import CritiCalModels
import CritiCalExtensions

public extension GenreEntity {
    /// SwiftUI Color derived from the hex color string
    @MainActor
    var color: Color {
        guard
            let colorToken = ColorToken(rawValue: colorName)
        else { return .accentColor }

        return colorToken.color
    }
}

