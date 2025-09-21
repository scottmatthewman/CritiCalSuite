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
    public let venueName: String

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
}
