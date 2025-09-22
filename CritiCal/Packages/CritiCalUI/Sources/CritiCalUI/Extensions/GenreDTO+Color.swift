//
//  GenreDTO+Color.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI
import CritiCalDomain

public extension GenreDTO {
    /// SwiftUI Color derived from the hex color string
    var color: Color {
        Color(hex: hexColor)
    }
}