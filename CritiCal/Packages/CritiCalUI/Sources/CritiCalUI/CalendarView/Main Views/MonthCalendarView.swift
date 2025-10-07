//
//  MonthCalendarView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI

public struct MonthCalendarView: View {
    @Binding var selectedDate: Date
    let namespace: Namespace.ID

    @Environment(\.calendar) private var calendar
    @Environment(\.layoutDirection) private var layoutDirection

    @State private var month: Date
    @State private var slideDirection: SlideDirection = .forward

    public init(
        selectedDate: Binding<Date>,
        namespace: Namespace.ID
    ) {
        self.namespace = namespace
        _selectedDate = selectedDate
        _month = State(initialValue: selectedDate.wrappedValue)
    }

    public var body: some View {
        let rows = calendar.monthGrid(containing: month)

        VStack {
            Grid(alignment: .top, horizontalSpacing: 0, verticalSpacing: 0) {
                GridRow {
                    WeekdayHeaderRow()
                }

                ForEach(rows.indices, id: \.self) { row in
                    let rowDates = rows[row]
                    GridRow {
                        ForEach(rowDates, id: \.self, content: dayCell)
                    }
                    .background {
                        if isSelectedRow(rowDates) {
                            currentWeekBackground
                        }
                    }
                }
            }
            .id(calendar.monthIdentity(containing: month))
            .transition(slideTransition)
            .compositingGroup()
            .onChange(of: selectedDate, handleSelectedDateChange)
        }
        .simultaneousGesture(swipeGesture)
    }

    private func isSelectedRow(_ dates: [Date]) -> Bool {
        dates.contains { date in
            calendar
                .isDate(date, equalTo: selectedDate, toGranularity: .weekOfYear)
        }
    }

    private var currentWeekBackground: some View {
        Color.clear.matchedGeometryEffect(
            id: CalendarNS.currentWeek,
            in: namespace,
            properties: .position,
            anchor: .topLeading
        )
    }

    private func dayCell(date: Date) -> some View {
        CalendarDayCell(
            date: date,
            selectedDate: $selectedDate,
            isInCurrentMonth: calendar.isDate(date, equalTo: month, toGranularity: .month),
            namespace: namespace
        )

    }

    private var slideTransition: AnyTransition {
        .calendarSlide(
            direction: slideDirection,
            isRTL: layoutDirection == .rightToLeft
        )
    }

    private var swipeGesture: some Gesture {
        horizontalPagingGesture(
            onPrevious: previousMonth,
            onNext: nextMonth
        )
    }

    private func handleSelectedDateChange() {
        // Only update the visible month (with animation) when selection moves to a different month
        if !calendar.isSameMonth(selectedDate, month) {
            // Determine direction based on chronological order, respecting current month
            slideDirection = (selectedDate > month) ? .forward : .backward
            withAnimation(AnimationStyle.slide) {
                month = selectedDate
            }
        }
    }

    private func previousMonth() {
        if let newDate = calendar.date(
            byAdding: .month,
            value: -1,
            to: month
        ) {
            slideDirection = .backward
            withAnimation(AnimationStyle.slide) {
                month = newDate
                selectedDate = newDate
            }
        }
    }

    private func nextMonth() {
        if let newDate = calendar.date(
            byAdding: .month,
            value: 1,
            to: month
        ) {
            slideDirection = .forward
            withAnimation(AnimationStyle.slide) {
                month = newDate
                selectedDate = newDate
            }
        }
    }

    private func returnToToday() {
        self.selectedDate = Date.now
    }
}

#Preview {
    @Previewable @State var selectedDate: Date = .now
    @Previewable @Namespace var namespace

    MonthCalendarView(selectedDate: $selectedDate, namespace: namespace)
}

