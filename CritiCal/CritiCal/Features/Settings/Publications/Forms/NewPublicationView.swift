//
//  NewPublicationView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import CritiCalCore
import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

struct NewPublicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var model = PublicationFormModel()

    var body: some View {
        NavigationStack {
            PublicationForm(model: model)
                .navigationTitle("New Publication")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel, action: cancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm, action: save)
                            .disabled(!model.isValid)
                    }
                }
                .toolbarTitleDisplayMode(.inline)
        }
    }
    private func cancel() {
        dismiss()
    }

    private func save() {
        guard model.isValid else { return }

        let publication = Publication(
            name: model.name,
            details: model.details,
            colorName: model.colorToken.rawValue,
            url: URL(string: model.urlString),
            typicalWordCount: model.typicalWordCount,
            typicalFee: model.typicalFee,
            awardsStars: model.awardsStars,
            isDeactivated: model.isDeactivated
        )

        modelContext.insert(publication)

        dismiss()
    }
}

#Preview {
    NewPublicationView()
}
