//
//  EventEntity+TestHelpers.swift
//  CritiCalIntentsTests
//
//  Test-only convenience initializer for EventEntity
//

import Foundation
import CritiCalDomain
import CritiCalModels
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
        // Create a DetachedEvent and use the existing initializer
        let event = DetachedEvent(
            id: id,
            title: title,
            festivalName: festivalName,
            date: date,
            durationMinutes: endDate.map { Int($0.timeIntervalSince(date) / 60) },
            venueName: venueName,
            confirmationStatus: confirmationStatus.confirmationStatus,
            url: nil,
            details: "",
            genre: nil
        )
        self.init(from: event)
    }
}
