//
//  ConfirmationStatus.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 21/09/2025.
//
import Foundation

public enum ConfirmationStatus: String, Equatable, Sendable, CaseIterable {
    case draft
    case tentative
    case bidForReview
    case awaitingConfirmation
    case confirmed
    case cancelled
}

// Mark: Representation

public extension ConfirmationStatus {
    var displayName: LocalizedStringResource {
        switch self {
        case .draft:
            "Draft"
        case .tentative:
            "Tentative"
        case .bidForReview:
            "Bid for Review"
        case .awaitingConfirmation:
            "Awaiting Confirmation"
        case .confirmed:
            "Confirmed"
        case .cancelled:
            "Cancelled"
        }
    }

    var displayDescription: LocalizedStringResource {
        switch self {
        case .draft:
            "Details are started but may be incomplete"
        case .tentative:
            "There's a possibility this will happen"
        case .bidForReview:
            "The possibility of a review has been requested"
        case .awaitingConfirmation:
            "Waiting for confirmation from the event organiser"
        case .confirmed:
            "Attendance at this event has been confirmed"
        case .cancelled:
            "This event, or your attendance, has been cancelled"
        }
    }
}

// MARK: Status collections

extension ConfirmationStatus {
    static let isConfirmed: Set<ConfirmationStatus> = [.confirmed]
    static let isPending: Set<ConfirmationStatus> = [
        .draft,
        .tentative,
        .bidForReview,
        .awaitingConfirmation
    ]
    static let isDraft: Set<ConfirmationStatus> = [.draft]
    static let isCancelled: Set<ConfirmationStatus> = [.cancelled]
}
