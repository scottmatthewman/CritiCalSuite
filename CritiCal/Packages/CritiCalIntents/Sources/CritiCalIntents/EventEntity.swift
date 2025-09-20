//
//  EventEntity.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import Foundation
import CritiCalDomain

public struct EventEntity: AppEntity, Identifiable, Sendable {
    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Event"
    public static let defaultQuery = EventQuery()

    public let id: UUID

    @Property(title: "Title")
    public var title: String

    @Property(title: "Date")
    public var date: Date

    @Property(title: "Venue Name")
    public var venueName: String

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)", subtitle: "\(venueName), \(date.formatted())")
    }

    public init(id: UUID, title: String, date: Date, venueName: String) {
        self.id = id
        self.title = title
        self.date = date
        self.venueName = venueName
    }
}
