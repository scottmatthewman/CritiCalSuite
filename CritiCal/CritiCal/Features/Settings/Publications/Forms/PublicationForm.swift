//
//  PublicationForm.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import SwiftUI

struct PublicationForm: View {
    @Bindable var model: PublicationFormModel

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
                    LargeGenreCircle(
                        symbolName: "newspaper",
                        color: model.colorToken
                            .color)
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
                    Toggle("Deactivate publication", isOn: $model.isDeactivated)
                        .focused($focused, equals: .isDeactivated)
                }
            }
            Section("Color") {
                ColorSelectionField(selection: $model.colorToken, columns: columns)
                    .focused($focused, equals: .color)
            }
            Section {
                TextField("Website URL", text: $model.urlString)
                Toggle("Awards Stars", isOn: $model.awardsStars)
            }
            Section("Review Defaults") {
                LabeledContent("Word Count") {
                    TextField(
                        "Typical word count",
                        value: $model.typicalWordCount,
                        format: .number,
                        prompt: Text("e.g., 400")
                    )
                    .labelsHidden()
                    .multilineTextAlignment(.trailing)
                }
                LabeledContent("Fee (£)") {
                    TextField(
                        "Typical fee",
                        value: $model.typicalFee,
                        format: .number,
                        prompt: Text("e.g., 80")
                    )
                    .labelsHidden()
                    .multilineTextAlignment(.trailing)
                }
            }
        }
        .defaultFocus($focused, .name, priority: .userInitiated)
    }
}
