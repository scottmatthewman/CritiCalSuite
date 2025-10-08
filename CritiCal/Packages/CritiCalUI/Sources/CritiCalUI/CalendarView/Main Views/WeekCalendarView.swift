//
//  WeekCalendarView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import CritiCalExtensions
import SwiftUI
import CritiCalModels

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    let events: [Event]
    let namespace: Namespace.ID

    @Environment(\.calendar) private var calendar
    @Environment(\.layoutDirection) private var layoutDirection

    @State private var slideDirection: SlideDirection = .forward
    @State private var visibleWeekStart: Date = Date()

    var body: some View {
        VStack {
            // Transitioning week days row
            Grid(alignment: .top, horizontalSpacing: 0, verticalSpacing: 0) {
                WeekdayHeaderRow()

                GridRow {
                    ForEach(daysInWeek, id: \.self) { date in
                        CalendarDayCell(
                            date: date,
                            selectedDate: $selectedDate,
                            isInCurrentMonth: nil,
                            hasEvents: hasEvents(on: date),
                            namespace: namespace
                        )
                    }
                }
                .background {
                    Color.clear.matchedGeometryEffect(
                        id: CalendarNS.currentWeek,
                        in: namespace,
                        properties: .position,
                        anchor: .topLeading
                    )
                }
            }
            .id(weekIdentity)
            .transition(slideTransition)
            .simultaneousGesture(swipeGesture)
        }
        .onAppear(perform: handleOnAppear)
        .onChange(of: selectedDate, handleSelectedDateChange)
    }

    private var slideTransition: AnyTransition {
        .calendarSlide(
            direction: slideDirection,
            isRTL: layoutDirection == .rightToLeft
        )
    }

    private var swipeGesture: some Gesture {
        horizontalPagingGesture(
            onPrevious: previousWeek,
            onNext: nextWeek
        )
    }

    private func handleOnAppear() {
        visibleWeekStart = weekStart
    }

    private func handleSelectedDateChange() {
        let newStart = calendar.startOfWeek(containing: selectedDate)
        if newStart != visibleWeekStart {
            let forward = newStart > visibleWeekStart
            // Set direction first so both halves of the transition read the same value
            slideDirection = forward ? .forward : .backward
            withAnimation(AnimationStyle.slide) {
                visibleWeekStart = newStart
            }
        }
    }

    private func previousWeek() {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: -1, to: selectedDate) {
            slideDirection = .backward
            withAnimation(AnimationStyle.slide) {
                selectedDate = newDate
                visibleWeekStart = calendar.startOfWeek(containing: newDate)
            }
        }
    }

    private func nextWeek() {
        if let newDate = calendar.date(byAdding: .weekOfYear, value: 1, to: selectedDate) {
            slideDirection = .forward
            withAnimation(AnimationStyle.slide) {
                selectedDate = newDate
                visibleWeekStart = calendar.startOfWeek(containing: newDate)
            }
        }
    }

    private var daysInWeek: [Date] {
        calendar.daysInWeek(containing: visibleWeekStart)
    }

    private var weekIdentity: String {
        calendar.weekIdentity(containing: visibleWeekStart)
    }

    private var weekStart: Date {
        calendar.startOfWeek(containing: selectedDate)
    }
    
    // Helper method to check if a date has events
    private func hasEvents(on date: Date) -> Bool {
        events.contains { event in
            calendar.isDate(event.date, inSameDayAs: date)
        }
    }
}

