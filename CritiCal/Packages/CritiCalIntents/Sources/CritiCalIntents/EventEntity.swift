//
//  EventEntity.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import Foundation
import CritiCalDomain
import CritiCalModels

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

    @Property(title: "End Date")
    public var endDate: Date

    @Property(title: "Venue Name")
    public var venueName: String

    @Property(title: "Status")
    public var confirmationStatus: ConfirmationStatusAppEnum

    @Property(title: "Genre")
    public var genre: GenreEntity?

    @Property(title: "URL")
    public var url: URL?

    @Property(title: "Description")
    public var details: String

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

    public init(from dto: EventDTO) {
        self.id = dto.id
        self.title = dto.title
        self.festivalName = dto.festivalName
        self.date = dto.date
        self.endDate = dto.endDate
        self.venueName = dto.venueName
        self.confirmationStatus = ConfirmationStatusAppEnum(
            dto.confirmationStatus
        ) ?? .draft
        self.url = dto.url
        self.details = dto.details
        self.genre = dto.genre.map { GenreEntity(from: $0) }
    }

    public init(from event: DetachedEvent) {
        self.id = event.id
        self.title = event.title
        self.festivalName = event.festivalName
        self.date = event.date
        self.endDate = event.endDate
        self.venueName = event.venueName
        self.confirmationStatus = ConfirmationStatusAppEnum(
            event.confirmationStatus
        ) ?? .draft
        self.url = event.url
        self.details = event.details
        self.genre = event.genre.map { GenreEntity(from: $0) }
    }
}
