//
//  CalendarDayCell.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//


import SwiftUI

internal struct CalendarDayCell: View {
    let date: Date
    @Binding var selectedDate: Date
    let isInCurrentMonth: Bool?   // pass nil for week mode
    let namespace: Namespace.ID
    @Environment(\.calendar) private var calendar

    var body: some View {
        Button {
            selectedDate = date
        } label: {
            Text("\(calendar.component(.day, from: date))")
                .font(.subheadline)
                .fontDesign(.rounded)
                .fontWeight((isInCurrentMonth ?? true) ? .semibold : .light)
                .foregroundStyle(foregroundStyle)
                .frame(maxWidth: .infinity, maxHeight: 34)
                .background(
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(.tint)
                                .matchedGeometryEffect(
                                    id: CalendarNS.selectedDay,
                                    in: namespace,
                                    properties: .position,
                                    anchor: .center
                                )
                        }
                    }
                )
                .frame(maxWidth: .infinity, minHeight: 44)
        }
        .contentShape(.rect)
        .buttonStyle(.plain)
        .weekendBackground(isWeekend)
        .animation(AnimationStyle.slide, value: isSelected)
    }

    private var isSelected: Bool { calendar.isDate(selectedDate, inSameDayAs: date) }
    private var isToday: Bool { calendar.isDateInToday(date) }
    private var isWeekend: Bool { calendar.isDateInWeekend(date) }

    private var foregroundStyle: some ShapeStyle {
        if isSelected { AnyShapeStyle(Color.white) }
        else if isToday { AnyShapeStyle(TintShapeStyle.tint) }
        else if let inMonth = isInCurrentMonth, !inMonth { AnyShapeStyle(Color.secondary) }
        else { AnyShapeStyle(Color.primary) }
    }
}
