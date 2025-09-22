//
//  GenreEntity.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 22/09/2025.
//

import AppIntents
import Foundation
import CritiCalDomain

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

    public init(from dto: GenreDTO) {
        self.id = dto.id
        self.name = dto.name
        self.details = dto.details
        self.hexColor = dto.hexColor
        self.isActive = !dto.isDeactivated
    }
}