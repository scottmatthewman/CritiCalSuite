//
//  EventDTO+DetachedEvent.swift
//  CritiCalIntentsTests
//
//  Created by Claude on 25/09/2025.
//

import Foundation
import CritiCalDomain
import CritiCalModels
@testable import CritiCalIntents

extension DetachedGenre {
    /// Create a DetachedGenre from a GenreDTO for testing purposes
    init(from dto: GenreDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            details: dto.details,
            colorName: dto.name, // Use name as colorName
            hexColor: dto.hexColor,
            symbolName: dto.symbolName,
            isDeactivated: dto.isDeactivated
        )
    }
}

extension GenreDTO {
    /// Create a DetachedGenre from this GenreDTO for testing purposes
    func detached() -> DetachedGenre {
        DetachedGenre(from: self)
    }
}

extension DetachedEvent {
    /// Create a DetachedEvent from an EventDTO for testing purposes
    init(from dto: EventDTO) {
        self.init(
            id: dto.id,
            title: dto.title,
            festivalName: dto.festivalName,
            date: dto.date,
            durationMinutes: dto.durationMinutes,
            venueName: dto.venueName,
            confirmationStatus: dto.confirmationStatus,
            url: dto.url,
            details: dto.details,
            genre: dto.genre?.detached()
        )
    }
}

extension Array where Element == EventDTO {
    /// Convert an array of EventDTOs to DetachedEvents for testing
    func detached() -> [DetachedEvent] {
        return self.map { DetachedEvent(from: $0) }
    }
}