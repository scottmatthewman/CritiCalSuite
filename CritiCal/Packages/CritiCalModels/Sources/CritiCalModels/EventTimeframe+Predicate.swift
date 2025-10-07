//
//  EventTimeframe+Predicate.swift
//  CritiCalModels
//
//  Created by Claude on 29/09/2025.
//

import Foundation
import SwiftData

public extension EventTimeframe {
    /// Creates a SwiftData predicate for filtering events based on the timeframe
    func predicate(calendar: Calendar = .current, now: Date = .now) -> Predicate<Event> {
        switch self {
        case .today:
            guard let range = calendar.dateInterval(of: .day, for: now) else {
                return #Predicate<Event> { _ in false }
            }
            let start = range.start
            let end = range.end
            return #Predicate<Event> { event in
                event.date >= start && event.date < end
            }

        case .past:
            let cutOff = now
            return #Predicate<Event> { event in
                event.date < cutOff
            }

        case .future:
            let cutOff = now
            return #Predicate<Event> { event in
                event.date >= cutOff
            }

        case .next7Days:
            guard
                let startOfToday = calendar.dateInterval(of: .day, for: now)?.start,
                let endOf7Days = calendar.date(byAdding: .day, value: 7, to: startOfToday)
            else {
                return #Predicate<Event> { _ in false }
            }
            let start = startOfToday
            let end = endOf7Days
            return #Predicate<Event> { event in
                event.date >= start && event.date < end
            }

        case .thisMonth:
            guard let range = calendar.dateInterval(of: .month, for: now) else {
                return #Predicate<Event> { _ in false }
            }
            let start = range.start
            let end = range.end
            return #Predicate<Event> { event in
                event.date >= start && event.date <= end
            }
        }
    }

    /// Returns the appropriate sort order for this timeframe
    var sortOrder: SortOrder {
        switch self {
        case .past:
            return .reverse  // Most recent first
        case .today, .future, .next7Days, .thisMonth:
            return .forward  // Chronological order
        }
    }
}