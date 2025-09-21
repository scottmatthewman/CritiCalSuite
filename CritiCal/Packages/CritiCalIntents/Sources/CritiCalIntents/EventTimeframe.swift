//
//  EventTimeframe.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalStore

public enum EventTimeframe: String, AppEnum, Sendable {
    case today, past, future, next7Days, thisMonth

    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Timeframe"
    public static let caseDisplayRepresentations: [EventTimeframe : DisplayRepresentation] = [
        .today: "Today",
        .past: "Past Events",
        .future: "Future Events",
        .next7Days: "Next 7 Days",
        .thisMonth: "This Month"
    ]
}

