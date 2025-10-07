//
//  Calendar+Weekdays.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import Foundation

/// A simple struct to hold weekday information.
/// This is locale-independent; the enclosing view will select the correct
/// symbol text for the locale.
struct WeekdayInfo: Hashable {
    let symbol: String
    let isWeekend: Bool
}

extension Calendar {
    var orderedWeekdayInfo: [WeekdayInfo] {
        let symbols = shortStandaloneWeekdaySymbols
        let start = firstWeekday - 1
        let ordered = Array(symbols[start...] + symbols[..<start])
        let weekStart = dateInterval(of: .weekOfYear, for: Date())!.start

        return (0..<daysPerWeek).map { i in
            let d = date(byAdding: .day, value: i, to: weekStart) ?? weekStart
            return WeekdayInfo(symbol: ordered[i], isWeekend: isDateInWeekend(d))
        }
    }
}
