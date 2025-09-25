//
//  File 2.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 21/09/2025.
//

import AppIntents
import CritiCalDomain
import Foundation

public enum ConfirmationStatusAppEnum: String, CaseIterable, AppEnum {
    case draft = "draft"
    case tentative = "tentative"
    case bidForReview = "bidForReview"
    case awaitingConfirmation = "awaitingConfirmation"
    case confirmed = "confirmed"
    case cancelled = "cancelled"

    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Confirmation Status"

    public static let caseDisplayRepresentations: [ConfirmationStatusAppEnum : DisplayRepresentation] = [
        .draft: DisplayRepresentation(
            title: "Draft",
            subtitle: "Details are started but may be incomplete",
            image: .init(systemName: "pencil.circle")
        ),
        .tentative: DisplayRepresentation(
            title: "Tentative",
            subtitle: "There's a possibility this will happen",
            image: .init(systemName: "circle.dashed")
        ),
        .bidForReview: DisplayRepresentation(
            title: "Bid for Review",
            subtitle: "A bid has been submitted and is under review",
            image: .init(systemName: "hand.raised.circle")
        ),
        .awaitingConfirmation: DisplayRepresentation(
            title: "Awaiting Confirmation",
            subtitle: "Waiting for confirmation from the event organiser",
            image: .init(systemName: "questionmark.circle")
        ),
        .confirmed: DisplayRepresentation(
            title: "Confirmed",
            subtitle: "Attendance at this event has been confirmed",
            image: .init(systemName: "checkmark.circle")
        ),
        .cancelled: DisplayRepresentation(
            title: "Cancelled",
            subtitle: "This event, or your attendance, has been cancelled",
            image: .init(systemName: "circle.slash")
        )
    ]
}

extension ConfirmationStatusAppEnum {
    // Conversion helpers
    public init?(_ status: ConfirmationStatus?) {
        guard let status = status,
              let appEnum = ConfirmationStatusAppEnum(rawValue: status.rawValue) else {
            return nil
        }
        self = appEnum
    }

    public var confirmationStatus: ConfirmationStatus {
        ConfirmationStatus(rawValue: self.rawValue) ?? .draft
    }
}
