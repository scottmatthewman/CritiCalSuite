//
//  File.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 11/10/2025.
//

import Foundation

public extension ConfirmationStatus {
    /// A variant of the ``displayName`` as a verb, for selection menus
    var actionDisplayName: LocalizedStringResource {
        switch self {
        case .confirmed: "Confirm"
        case .cancelled: "Cancel"
        default: displayName
        }
    }

    /// Status views that are available as the quick next action selection
    /// from a given starting point.
    var nextActions: [ConfirmationStatus] {
        switch self {
        case .draft:
            [
                .tentative,
                .bidForReview,
                .awaitingConfirmation,
                .confirmed,
                .cancelled
            ]
        case .tentative, .bidForReview:
            [.awaitingConfirmation, .confirmed, .cancelled]
        case .awaitingConfirmation:
            [.confirmed, .cancelled]
        case .confirmed:
            [.cancelled]
        case .cancelled:
            []
        }
    }
}
