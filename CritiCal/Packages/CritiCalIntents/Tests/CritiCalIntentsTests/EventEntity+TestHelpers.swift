//
//  EventEntity+TestHelpers.swift
//  CritiCalIntentsTests
//
//  Test-only convenience initializer for EventEntity
//

import Foundation
import CritiCalDomain
@testable import CritiCalIntents

extension EventEntity {
    /// Convenience initializer for tests only
    init(
        id: UUID = UUID(),
        title: String,
        festivalName: String = "",
        date: Date,
        endDate: Date? = nil,
        venueName: String = "",
        confirmationStatus: ConfirmationStatusAppEnum = .draft
    ) {
        // Create a DTO and use the existing initializer
        let dto = EventDTO(
            id: id,
            title: title,
            festivalName: festivalName,
            date: date,
            durationMinutes: endDate.map { Int($0.timeIntervalSince(date) / 60) },
            venueName: venueName,
            confirmationStatus: confirmationStatus.confirmationStatus
        )
        self.init(from: dto)
    }
}
