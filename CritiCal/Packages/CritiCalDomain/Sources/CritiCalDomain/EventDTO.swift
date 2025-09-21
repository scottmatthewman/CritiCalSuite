//
//  EventDTO.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 18/09/2025.
//

import Foundation

public struct EventDTO: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let festivalName: String
    public let date: Date
    public let durationMinutes: Int?
    public let venueName: String

    public init(
        id: UUID = UUID(),
        title: String,
        festivalName: String = "",
        date: Date,
        durationMinutes: Int? = nil,
        venueName: String = ""
    ) {
        self.id = id
        self.title = title
        self.festivalName = festivalName
        self.date = date
        self.durationMinutes = durationMinutes
        self.venueName = venueName
    }

    /// The calculated end date of the event, based on date + durationMinutes
    public var endDate: Date {
        guard let durationMinutes else { return date }
        return Calendar.current.date(byAdding: .minute, value: durationMinutes, to: date) ?? date
    }
}
