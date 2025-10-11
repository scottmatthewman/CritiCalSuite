//
//  GenreForm.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalUI
import SwiftUI

struct GenreForm: View {
    @Bindable var model: GenreFormModel

    @Environment(\.dynamicTypeSize) private var typeSize
    @Environment(\.horizontalSizeClass) private var hSize

    @FocusState private var focused: FormFocus?

    @State private var iconSearch: String = ""

    enum FormFocus {
        case name
        case description
        case isDeactivated
        case color
        case iconSearch
        case icon
    }

    private var columns: [GridItem] {
        let base = (hSize == .compact) ? 7 : 8
        let count = max(3, base - (typeSize.isAccessibilitySize ? 2 : 0))
        return Array(
            repeating: GridItem(.flexible(minimum: 40, maximum: 80), spacing: 12),
            count: count
        )
    }

    var body: some View {
        Form {
            Section {
                VStack(spacing: 12) {
                    CircularIcon(systemImage: model.symbolName, diameter: 100)
                        .tint(model.color)
                    TextField("Name", text: $model.name)
                        .textInputAutocapitalization(.words)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(4)
                        .background(
                            .thinMaterial,
                            in: .rect(cornerRadius: 12)
                        )
                        .focused($focused, equals: .name)
                }
                TextField(
                    "Description (optional)",
                    text: $model.details,
                    axis: .vertical
                )
                .lineLimit(1...3)
                .focused($focused, equals: .description)
                Toggle("Deactivate genre", isOn: $model.isDeactivated)
                    .focused($focused, equals: .isDeactivated)
            }
            Section("Color") {
                ColorTokenField(selection: $model.colorToken, columns: columns)
                    .focused($focused, equals: .color)
            }
            Section("Icon") {
                TextField("Search", text: $iconSearch)
                    .padding(.vertical, 2)
                    .padding(.horizontal, 8)
                    .background(.tertiary, in: .capsule)
                AppSymbolField(selectedSymbol: $model.symbolName, columns: columns)
                    .focused($focused, equals: .icon)
            }
        }
        .defaultFocus($focused, .name, priority: .userInitiated)
    }
}
