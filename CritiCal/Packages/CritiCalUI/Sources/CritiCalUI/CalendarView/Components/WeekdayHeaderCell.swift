//
//  WeekdayHeaderCell.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI

struct WeekdayHeaderCell: View {
    let info: WeekdayInfo

    @ScaledMetric(relativeTo: .caption) private var minHeight = 24

    var body: some View {
        Text(info.symbol)
            .font(.caption)
            .textCase(.uppercase)
            .frame(maxWidth: .infinity, minHeight: minHeight)
            .foregroundStyle(info.isWeekend ? .secondary : .primary)
    }
}

#Preview {
    WeekdayHeaderCell(info: WeekdayInfo(symbol: "Sun", isWeekend: true))
}

extension View {
    func weekendBackground(_ isWeekend: Bool) -> some View {
        self
            .background(.quinary.opacity(isWeekend ? 1.0 : 0.0))
    }
}
