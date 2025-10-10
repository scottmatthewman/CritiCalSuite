//
//  DetachedGenre.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalCore
import CritiCalExtensions
import Foundation
import SwiftUI

/// A detached, value-type copy of a Genre that can safely cross actor boundaries.
/// This is a lightweight version of Genre for use when passing data between actors.
public struct DetachedGenre: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let name: String
    nonisolated public let details: String
    nonisolated public let colorToken: ColorToken
    nonisolated public let symbolName: String
    nonisolated public let isDeactivated: Bool

    nonisolated public init(
        id: UUID,
        name: String,
        details: String,
        colorToken: ColorToken,
        symbolName: String,
        isDeactivated: Bool
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.colorToken = colorToken
        self.symbolName = symbolName
        self.isDeactivated = isDeactivated
    }

    /// Computed property for SwiftUI Color
    public var color: Color {
        colorToken.color
    }
}

public extension Genre {
    /// Create a detached copy of this Genre that can safely cross actor boundaries
    func detached() -> DetachedGenre {
        DetachedGenre(
            id: identifier ?? UUID(),
            name: name,
            details: details,
            colorToken: colorToken,
            symbolName: symbolName,
            isDeactivated: isDeactivated
        )
    }
}
