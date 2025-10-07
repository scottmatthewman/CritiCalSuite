//
//  Calendar+utilities.swift
//  CritiCalExtensions
//
//  Created by Scott Matthewman on 05/10/2025.
//

import Foundation

public extension Calendar {
    func weekInterval(containing date: Date) -> DateInterval {
        dateInterval(of: .weekOfYear, for: date) ?? fallbackInterval(for: date)
    }

    func monthInterval(containing date: Date) -> DateInterval {
        dateInterval(of: .month, for: date) ?? fallbackInterval(for: date)
    }

    private func fallbackInterval(for date: Date) -> DateInterval {
        DateInterval(start: startOfDay(for: date), end: startOfDay(for: date))
    }

    func startOfWeek(containing date: Date) -> Date {
        weekInterval(containing: date).start
    }

    var daysPerWeek: Int {
        maximumRange(of: .weekday)?.count ?? 7
    }

    // Convenience for a "display end" that lands inside the last day of the week.
    func endOfWeekInclusive(containing date: Date) -> Date {
        let interval = weekInterval(containing: date)
        return interval.end.addingTimeInterval(-1)
    }

    func daysInWeek(containing date: Date) -> [Date] {
        let start = startOfWeek(containing: date)
        return (0..<daysPerWeek).compactMap { day in
            self.date(byAdding: .day, value: day, to: start)
        }
    }

    func monthGrid(containing date: Date) -> [[Date]] {
        let days = daysForMonthGrid(containing: date)
        return days.chunked(into: daysPerWeek)
    }

    // Days to render for a full month grid: includes leading/trailing days to fill first/last weeks.
    func daysForMonthGrid(containing date: Date) -> [Date] {
        let monthInterval = monthInterval(containing: date)

        guard
            let firstWeekStart = dateInterval(of: .weekOfYear, for: monthInterval.start)?.start,
            let lastWeekEnd = dateInterval(of: .weekOfYear, for: monthInterval.end.addingTimeInterval(-1))?.end
        else {
            return []
        }

        var days: [Date] = []
        var d = firstWeekStart
        while d < lastWeekEnd {
            days.append(d)
            d = self.date(byAdding: .day, value: 1, to: d)!
        }
        return days
    }

    func weekIdentity(containing date: Date) -> String {
        let comps = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return "\(comps.yearForWeekOfYear ?? 0)-\(comps.weekOfYear ?? 0)"
    }

    func monthIdentity(containing date: Date) -> String {
        let comps = dateComponents([.year, .month], from: date)
        return "\(comps.year ?? 0)-\(comps.month ?? 0)"
    }

    func isSameMonth(_ a: Date, _ b: Date) -> Bool {
        isDate(a, equalTo: b, toGranularity: .month)
    }
}
