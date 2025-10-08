//
//  CalendarDayCell.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//


import SwiftUI
import CritiCalModels

internal struct CalendarDayCell: View {
    let date: Date
    @Binding var selectedDate: Date
    let isInCurrentMonth: Bool?   // pass nil for week mode
    let events: [Event]
    let namespace: Namespace.ID
    @Environment(\.calendar) private var calendar

    var body: some View {
        Button {
            selectedDate = date
        } label: {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .fontWeight((isInCurrentMonth ?? true) ? .semibold : .light)
                    .foregroundStyle(foregroundStyle)
                
                // Event indicators - up to 4 colored dots
                HStack(spacing: 1) {
                    ForEach(Array(displayEvents.enumerated()), id: \.offset) { _, event in
                        Circle()
                            .fill(eventColor(for: event))
                            .frame(width: 3, height: 3)
                            .opacity(eventOpacity(for: event))
                    }
                }
                .frame(height: 4)
                .opacity(events.isEmpty ? 0.0 : 1.0)
                .scaleEffect(events.isEmpty ? 0.1 : 1.0)
                .animation(AnimationStyle.slide, value: events.count)
            }
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
    
    // Limit to 4 events maximum for display
    private var displayEvents: [Event] {
        Array(events.prefix(4))
    }
    
    // Get color for an event based on its genre
    private func eventColor(for event: Event) -> Color {
        if isSelected {
            return Color.white
        } else if let genre = event.genre {
            return genre.color
        } else {
            return Color.accentColor
        }
    }
    
    // Get opacity for an event based on its confirmation status
    private func eventOpacity(for event: Event) -> Double {
        switch event.confirmationStatus {
        case .confirmed:
            return 1.0
        case .cancelled:
            return 0.4
        case .draft, .tentative, .bidForReview, .awaitingConfirmation:
            return 0.6
        }
    }

    private var foregroundStyle: some ShapeStyle {
        if isSelected { AnyShapeStyle(Color.white) }
        else if isToday { AnyShapeStyle(TintShapeStyle.tint) }
        else if let inMonth = isInCurrentMonth, !inMonth { AnyShapeStyle(Color.secondary) }
        else { AnyShapeStyle(Color.primary) }
    }
}
