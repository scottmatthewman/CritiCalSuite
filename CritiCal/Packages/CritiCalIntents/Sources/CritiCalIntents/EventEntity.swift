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

    @Property(title: "Festival Name")
    public var festivalName: String

    @Property(title: "Date")
    public var date: Date

    @Property(title: "Venue Name")
    public var venueName: String

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: displayTitle, subtitle: displaySubtitle)
    }

    private var displayTitle: LocalizedStringResource {
        if festivalName.isEmpty {
            "\(title)"
        } else {
            "\(title) (\(festivalName))"
        }
    }

    private var displaySubtitle: LocalizedStringResource {
        if venueName.isEmpty {
            "\(date.formatted())"
        } else {
            "\(venueName), \(date.formatted())"
        }
    }

    public init(
        id: UUID = UUID(),
        title: String,
        festivalName: String = "",
        date: Date,
        venueName: String = ""
    ) {
        self.id = id
        self.title = title
        self.festivalName = festivalName
        self.date = date
        self.venueName = venueName
    }

    public init(from dto: EventDTO) {
        self.id = dto.id
        self.title = dto.title
        self.festivalName = dto.festivalName
        self.date = dto.date
        self.venueName = dto.venueName
    }
}
