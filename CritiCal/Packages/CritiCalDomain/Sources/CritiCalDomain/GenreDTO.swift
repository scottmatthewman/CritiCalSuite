//
//  GenreDTO.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 22/09/2025.
//

import Foundation

public struct GenreDTO: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let name: String
    public let details: String
    public let hexColor: String
    public let isDeactivated: Bool

    public init(
        id: UUID = UUID(),
        name: String,
        details: String = "",
        hexColor: String = "888888",
        isDeactivated: Bool = false
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.hexColor = hexColor
        self.isDeactivated = isDeactivated
    }
}