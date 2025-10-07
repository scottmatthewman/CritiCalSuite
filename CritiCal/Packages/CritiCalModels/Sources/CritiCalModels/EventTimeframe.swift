//
//  EventTimeframe.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 18/09/2025.
//

import Foundation

#if canImport(AppIntents)
import AppIntents

public enum EventTimeframe: String, AppEnum, Sendable, CaseIterable {
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

#else

public enum EventTimeframe: String, Sendable, CaseIterable {
    case today, past, future, next7Days, thisMonth
}

#endif

extension EventTimeframe: CustomStringConvertible {
    public var description: String {
        switch self {
        case .today: "Today"
        case .past: "Past Events"
        case .future: "Future Events"
        case .next7Days: "Next 7 Days"
        case .thisMonth: "This Month"
        }
    }
}
