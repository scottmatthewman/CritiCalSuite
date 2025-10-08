//
//  DetachedGenre.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 25/09/2025.
//

import Foundation
import SwiftUI
import CritiCalExtensions

/// A detached, value-type copy of a Genre that can safely cross actor boundaries.
/// This is a lightweight version of Genre for use when passing data between actors.
public struct DetachedGenre: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let name: String
    nonisolated public let details: String
    nonisolated public let colorName: String
    nonisolated public let hexColor: String
    nonisolated public let symbolName: String
    nonisolated public let isDeactivated: Bool

    nonisolated public init(
        id: UUID,
        name: String,
        details: String,
        colorName: String,
        hexColor: String,
        symbolName: String,
        isDeactivated: Bool
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.colorName = colorName
        self.hexColor = hexColor
        self.symbolName = symbolName
        self.isDeactivated = isDeactivated
    }

    /// Computed property for SwiftUI Color
    nonisolated public var color: Color {
        Color(hex: hexColor)
    }
}

public extension Genre {
    /// Create a detached copy of this Genre that can safely cross actor boundaries
    func detached() -> DetachedGenre {
        DetachedGenre(
            id: identifier ?? UUID(),
            name: name,
            details: details,
            colorName: colorName,
            hexColor: hexColor,
            symbolName: symbolName,
            isDeactivated: isDeactivated
        )
    }
}
