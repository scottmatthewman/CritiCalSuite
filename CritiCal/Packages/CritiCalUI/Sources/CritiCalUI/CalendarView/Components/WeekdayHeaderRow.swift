//
//  WeekdayHeaderRow.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI

struct WeekdayHeaderRow: View {
    @Environment(\.calendar) private var calendar

    var body: some View {
        GridRow {
            ForEach(calendar.orderedWeekdayInfo, id: \.self) { info in
                WeekdayHeaderCell(info: info)
            }
        }
    }
}
