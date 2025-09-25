//
//  GenreEntity+Color.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI
import CritiCalExtensions

public extension GenreEntity {
    /// SwiftUI Color derived from the hex color string
    var color: Color {
        Color(hex: hexColor)
    }
}
