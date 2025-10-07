//
//  MonthTitleButton.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//


import SwiftUI

internal struct MonthTitleButton: View {
    @Binding var date: Date
    let onTap: () -> Void

    @State private var isShowingDatePicker = false
    @State private var suppressNextTap = false

    internal var body: some View {
        Button(action: {
            if suppressNextTap {
                suppressNextTap = false
                return
            }
            onTap()
        }) {
            HStack(spacing: 6) {
                Text(date, format: .dateTime.month(.wide))
                Text(date, format: .dateTime.year())
                    .foregroundStyle(.tint)
                    .monospacedDigit()
                    .contentTransition(.numericText())
            }
            .animation(AnimationStyle.slide, value: date)
        }
        .popover(isPresented: $isShowingDatePicker, attachmentAnchor: .rect(.bounds), arrowEdge: .top) {
            VStack(alignment: .leading) {
                DatePicker("", selection: $date, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            .padding()
            .presentationCompactAdaptation(.popover)
        }
        .buttonStyle(.plain)
        .highPriorityGesture(
            LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    suppressNextTap = true
                    isShowingDatePicker = true
                }
        )
        .onChange(of: isShowingDatePicker, handleIsShowingDatePickerChange)
    }

    private func handleIsShowingDatePickerChange() {
        if !isShowingDatePicker {
            suppressNextTap = false
        }
    }
}

