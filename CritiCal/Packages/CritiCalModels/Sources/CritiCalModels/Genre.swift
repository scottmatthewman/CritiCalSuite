//
//  Genre.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation
import SwiftData

@Model
public final class Genre {
    /// The unique identifier for the genre.
    public var identifier: UUID?

    public var name: String = ""
    public var details: String = ""
    public var colorName: String = "amber"
    public var hexColor: String = "888888"
    public var symbolName: String = "theatermasks"
    public var isDeactivated: Bool = false

    @Relationship
    public var events: [Event]?

    public init(
        identifier: UUID? = UUID(),
        name: String,
        details: String = "",
        colorName: String = "amber",
        hexColor: String = "888888",
        symbolName: String = "theatermasks",
        isDeactivated: Bool = false
    ) {
        self.identifier = identifier
        self.name = name
        self.details = details
        self.colorName = colorName
        self.hexColor = hexColor
        self.symbolName = symbolName
        self.isDeactivated = isDeactivated
    }
}
