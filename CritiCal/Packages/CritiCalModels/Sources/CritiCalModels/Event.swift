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

    public init(
        identifier: UUID = UUID(),
        title: String = "",
        festivalName: String = "",
        venueName: String = "",
        date: Date = Date.now,
        durationMinutes: Int? = nil,
        confirmationStatusRaw: String? = "draft",
        genre: Genre? = nil
    ) {
        self.identifier = identifier
        self.title = title
        self.festivalName = festivalName
        self.venueName = venueName
        self.date = date
        self.durationMinutes = durationMinutes
        self.confirmationStatusRaw = confirmationStatusRaw
        self.genre = genre
    }
}
