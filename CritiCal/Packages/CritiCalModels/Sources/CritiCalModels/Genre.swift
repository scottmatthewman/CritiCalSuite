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
    public var hexColor: String = "888888"
    public var isDeactivated: Bool = false

    @Relationship
    public var events: [Event]?

    public init(
        identifier: UUID? = UUID(),
        name: String,
        details: String = "",
        hexColor: String = "888888",
        isDeactivated: Bool = false
    ) {
        self.identifier = identifier
        self.name = name
        self.details = details
        self.hexColor = hexColor
        self.isDeactivated = isDeactivated
    }
}
