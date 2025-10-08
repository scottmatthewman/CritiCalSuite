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
    public var url: URL?
    public var details: String = ""

    public var needsReview: Bool = false
    public var wordCount: Int?
    public var fee: Int?
    public var reviewCompleted: Bool = false
    public var reviewUrl: URL?
    public var rating: Double?

    @Relationship(deleteRule: .nullify, inverse: \Genre.events)
    public var genre: Genre?
    @Relationship(deleteRule: .nullify, inverse: \Publication.events)
    public var publication: Publication?

    // Computed property for type-safe access to confirmation status
    public var confirmationStatus: ConfirmationStatus {
        get {
            ConfirmationStatus(rawValue: confirmationStatusRaw ?? "draft") ?? .draft
        }
        set {
            confirmationStatusRaw = newValue.rawValue
        }
    }

    // Computed property for event end date
    public var endDate: Date {
        guard let durationMinutes else { return date }
        return Calendar.current.date(byAdding: .minute, value: durationMinutes, to: date) ?? date
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
        details: String = "",
        needsReview: Bool = false,
        wordCount: Int? = nil,
        fee: Int? = nil,
        reviewCompleted: Bool = false,
        reviwUrl: URL? = nil,
        rating: Double? = nil
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
        self.needsReview = needsReview
        self.wordCount = wordCount
        self.fee = fee
        self.reviewCompleted = reviewCompleted
        self.reviewUrl = reviewUrl
        self.rating = rating
    }
}
