//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI

public struct CalendarView: View {
    @Binding var selectedDate: Date
    var onVisibleRangeChange: ((DateInterval) -> Void)?

    @Environment(\.calendar) private var calendar
    @Namespace private var calendarNS
    @State private var viewType: CalendarViewType = .monthly

    init(
        selectedDate: Binding<Date>,
        onVisibleRangeChange: ((DateInterval) -> Void)? = nil
    ) {
        _selectedDate = selectedDate
        self.onVisibleRangeChange = onVisibleRangeChange
    }

    public var body: some View {
        VStack {
            MonthTitleButton(date: $selectedDate, onTap: returnToToday)
                .font(.title.bold())
                .frame(maxWidth: .infinity, alignment: .leading)

            switch viewType {
            case .monthly:
                MonthCalendarView(selectedDate: $selectedDate, namespace: calendarNS)
            case .weekly:
                WeekCalendarView(selectedDate: $selectedDate, namespace: calendarNS)
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
        onVisibleRangeChange?(visibleDateRange)
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
}

#Preview {
    @Previewable @State var date: Date = .now

    NavigationStack {
        VStack {
            CalendarView(selectedDate: $date) { dateInterval in
                print(date)
                print(dateInterval)
            }
            Spacer()
        }
        .navigationTitle("Events")
        .toolbarTitleDisplayMode(.inlineLarge)
    }
}
