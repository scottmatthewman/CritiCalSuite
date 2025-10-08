//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI
import CritiCalModels

public struct CalendarView: View {
    @Binding var selectedDate: Date
    let events: [Event]
    var onVisibleRangeChange: ((DateInterval) -> Void)?

    @Environment(\.calendar) private var calendar
    @Namespace private var calendarNS
    @State private var viewType: CalendarViewType = .monthly
    @State private var currentRange: DateInterval?

    init(
        selectedDate: Binding<Date>,
        events: [Event] = [],
        onVisibleRangeChange: ((DateInterval) -> Void)? = nil
    ) {
        _selectedDate = selectedDate
        self.events = events
        self.onVisibleRangeChange = onVisibleRangeChange
    }

    public var body: some View {
        VStack {
            MonthTitleButton(date: $selectedDate, onTap: returnToToday)
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            switch viewType {
            case .monthly:
                MonthCalendarView(selectedDate: $selectedDate, events: events, namespace: calendarNS)
            case .weekly:
                WeekCalendarView(selectedDate: $selectedDate, events: events, namespace: calendarNS)
            }
        }
        .scenePadding(.horizontal)
        .simultaneousGesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    let horizontal = value.translation.width
                    let vertical = value.translation.height
                    let shouldHandle = abs(vertical) > abs(horizontal) && abs(
                        vertical
                    ) > 40
                    guard shouldHandle else { return }
                    withAnimation(AnimationStyle.slide) {
                        if vertical < 0 {
                            viewType = .weekly
                        } else {
                            viewType = .monthly
                        }
                    }
                }
        )
        .onAppear(perform: handleDateRangeChange)
        .onChange(of: selectedDate, handleDateRangeChange)
        .onChange(of: viewType, handleDateRangeChange)
    }

    private func handleDateRangeChange() {
        let newRange = visibleDateRange
        if newRange != currentRange {
            currentRange = newRange
            onVisibleRangeChange?(newRange)
        }
    }

    private func returnToToday() {
        self.selectedDate = Date.now
    }

    private var visibleDateRange: DateInterval {
        switch viewType {
        case .weekly:
            calendar.dateInterval(of: .weekOfYear, for: selectedDate)!
        case .monthly:
            calendar.dateInterval(of: .month, for: selectedDate)!
        }
    }
    
    // Helper method to check if a date has events (for highlighting)
    internal func hasEvents(on date: Date) -> Bool {
        events.contains { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
}

#Preview {
    @Previewable @State var date: Date = .now

    NavigationStack {
        VStack {
            CalendarView(selectedDate: $date, events: []) { dateInterval in
                print(date)
                print(dateInterval)
            }
            Spacer()
        }
        .navigationTitle("Events")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}
