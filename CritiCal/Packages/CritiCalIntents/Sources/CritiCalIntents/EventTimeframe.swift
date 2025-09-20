//
//  EventTimeframe.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalStore

public enum EventTimeframe: String, AppEnum, Sendable {
    case today, past, future

    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "Timeframe"
    public static let caseDisplayRepresentations: [EventTimeframe : DisplayRepresentation] = [
        .today: "Today",
        .past: "Past Events",
        .future: "Future Events"
    ]
}

