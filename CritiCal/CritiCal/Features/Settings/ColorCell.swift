//
//  ColorCell.swift
//  CritiCal
//
//  Created by Scott Matthewman on 24/09/2025.
//

import SwiftUI

struct ColorCell: View {
    let color: Color
    let selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(color)
                if selected {
                    Circle()
                        .strokeBorder(.white.opacity(0.8), lineWidth: 2)
                        .overlay(
                            Image(systemName: "checkmark")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.8))
                        )
                }
            }
            .frame(width: 40, height: 40)
            .shadow(radius: 1, y: 1)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

#Preview {
    @Previewable @State var isSelected: Bool = true

    HStack {
        ColorCell(color: .teal, selected: isSelected) { isSelected.toggle() }
        ColorCell(color: .teal, selected: !isSelected) { isSelected.toggle() }
    }
}
