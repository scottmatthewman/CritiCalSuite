//
//  Event.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 18/09/2025.
//

import Foundation
import SwiftData

@Model
public final class Event {
    #Index<Event>([\.title], [\.date])

    public var identifier: UUID = UUID()
    @Attribute(.preserveValueOnDeletion) public var title: String = ""
    @Attribute(.preserveValueOnDeletion) public var date: Date = Date.now
    public var durationMinutes: Int?
    public var festivalName: String = ""
    public var venueName: String = ""
    public var confirmationStatusRaw: String?
    @Relationship(deleteRule: .nullify, inverse: \Genre.events)
    public var genre: Genre?
    public var url: URL?
    public var details: String = ""

    // Computed property for type-safe access to confirmation status
    public var confirmationStatus: ConfirmationStatus {
        get {
            ConfirmationStatus(rawValue: confirmationStatusRaw ?? "draft") ?? .draft
        }
        set {
            confirmationStatusRaw = newValue.rawValue
        }
    }

    public init(
        identifier: UUID = UUID(),
        title: String = "",
        festivalName: String = "",
        venueName: String = "",
        date: Date = Date.now,
        durationMinutes: Int? = nil,
        confirmationStatusRaw: String? = "draft",
        genre: Genre? = nil,
        url: URL? = nil,
        details: String = ""
    ) {
        self.identifier = identifier
        self.title = title
        self.festivalName = festivalName
        self.venueName = venueName
        self.date = date
        self.durationMinutes = durationMinutes
        self.confirmationStatusRaw = confirmationStatusRaw
        self.genre = genre
        self.url = url
        self.details = details
    }
}
