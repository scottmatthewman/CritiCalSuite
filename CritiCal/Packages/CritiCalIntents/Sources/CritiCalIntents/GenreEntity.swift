//
//  GenreEntity.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 22/09/2025.
//

import AppIntents
import CritiCalModels
import Foundation

public struct GenreEntity: AppEntity, Identifiable, Sendable {
    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Genre"
    public static let defaultQuery = GenreQuery()

    public let id: UUID

    @Property(title: "Name")
    public var name: String

    @Property(title: "Details")
    public var details: String

    @Property(title: "Color")
    public var hexColor: String

    @Property(title: "Is Active")
    public var isActive: Bool

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(name)",
            subtitle: details.isEmpty ? nil : "\(details)"
        )
    }

public init(from genre: DetachedGenre) {
        self.id = genre.id
        self.name = genre.name
        self.details = genre.details
        self.hexColor = genre.hexColor
        self.isActive = !genre.isDeactivated
    }
}
