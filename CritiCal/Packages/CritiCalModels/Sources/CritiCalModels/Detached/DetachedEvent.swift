//
//  DetachedEvent.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 25/09/2025.
//

import Foundation

/// A detached, value-type copy of an Event that can safely cross actor boundaries.
/// This is a lightweight version of Event for use when passing data between actors.
public struct DetachedEvent: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let title: String
    nonisolated public let festivalName: String
    nonisolated public let date: Date
    nonisolated public let durationMinutes: Int?
    nonisolated public let venueName: String
    nonisolated public let confirmationStatus: ConfirmationStatus
    nonisolated public let url: URL?
    nonisolated public let details: String
    nonisolated public let needsReview: Bool
    nonisolated public let wordCount: Int?
    nonisolated public let fee: Int?
    nonisolated public let reviewCompleted: Bool
    nonisolated public let reviewUrl: URL?
    nonisolated public let rating: Double?
    nonisolated public let genre: DetachedGenre?
    nonisolated public let publication: DetachedPublication?

    nonisolated public init(
        id: UUID,
        title: String,
        festivalName: String,
        date: Date,
        durationMinutes: Int?,
        venueName: String,
        confirmationStatus: ConfirmationStatus,
        url: URL?,
        details: String,
        needsReview: Bool,
        wordCount: Int?,
        fee: Int?,
        reviewCompleted: Bool,
        reviewUrl: URL?,
        rating: Double?,
        genre: DetachedGenre?,
        publication: DetachedPublication?
    ) {
        self.id = id
        self.title = title
        self.festivalName = festivalName
        self.date = date
        self.durationMinutes = durationMinutes
        self.venueName = venueName
        self.confirmationStatus = confirmationStatus
        self.url = url
        self.details = details
        self.needsReview = needsReview
        self.wordCount = wordCount
        self.fee = fee
        self.reviewCompleted = reviewCompleted
        self.reviewUrl = reviewUrl
        self.rating = rating
        self.genre = genre
        self.publication = publication
    }

    /// Computed property for event end date
    nonisolated public var endDate: Date {
        guard let durationMinutes else { return date }
        return Calendar.current.date(byAdding: .minute, value: durationMinutes, to: date) ?? date
    }
}

public extension Event {
    /// Create a detached copy of this Event that can safely cross actor boundaries
    func detached() -> DetachedEvent {
        DetachedEvent(
            id: identifier,
            title: title,
            festivalName: festivalName,
            date: date,
            durationMinutes: durationMinutes,
            venueName: venueName,
            confirmationStatus: confirmationStatus,
            url: url,
            details: details,
            needsReview: needsReview,
            wordCount: wordCount,
            fee: fee,
            reviewCompleted: reviewCompleted,
            reviewUrl: reviewUrl,
            rating: rating,
            genre: genre?.detached(),
            publication: publication?.detached()
        )
    }
}
