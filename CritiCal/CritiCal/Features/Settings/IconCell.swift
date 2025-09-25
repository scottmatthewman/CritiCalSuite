//
//  IconCell.swift
//  CritiCal
//
//  Created by Scott Matthewman on 24/09/2025.
//

import SwiftUI

struct IconCell: View {
    let name: String
    let selected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if selected {
                    Circle()
                        .fill(.tint.tertiary)
                }
                Image(systemName: name)
                    .font(.system(size: 22, weight: .regular))
                    .foregroundStyle(selected ? AnyShapeStyle(.tint) : AnyShapeStyle(.secondary))
            }
        }
        .frame(maxWidth: 44, maxHeight: 44)
        .buttonStyle(.plain)
    }
}

#Preview {
    @Previewable @State var isSelected: Bool = false

    HStack {
        IconCell(
            name: "theatermasks",
            selected: isSelected,
            action: { isSelected.toggle() }
        )
        IconCell(
            name: "checkmark.seal",
            selected: !isSelected,
            action: { isSelected.toggle() }
        )
    }
}
