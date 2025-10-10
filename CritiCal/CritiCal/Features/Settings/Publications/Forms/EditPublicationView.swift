//
//  EditPublicationView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import CritiCalCore
import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

struct EditPublicationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var model: PublicationFormModel
    private var publication: Publication

    init(publication: Publication) {
        self.publication = publication
        let model = PublicationFormModel(
            name: publication.name,
            colorToken: publication.colorToken,
            isDeactivated: publication.isDeactivated,
            urlString: publication.url?.absoluteString ?? "",
            typicalWordCount: publication.typicalWordCount,
            typicalFee: publication.typicalFee,
            awardsStars: publication.awardsStars
        )
        _model = State(initialValue: model)
    }

    var body: some View {
        NavigationStack {
            PublicationForm(model: model)
                .navigationTitle("Edit Publication")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(role: .cancel, action: cancel)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(role: .confirm, action: save)
                            .disabled(!model.isValid)
                    }
                }
        }
    }

    private func cancel() {
        dismiss()
    }

    private func save() {
        guard model.isValid else { return }

        publication.name = model.name
        publication.colorName = model.colorToken.rawValue
        publication.isDeactivated = model.isDeactivated

        publication.url = URL(string: model.urlString)
        publication.details = model.details
        publication.typicalWordCount = model.typicalWordCount
        publication.typicalFee = model.typicalFee
        publication.awardsStars = model.awardsStars

        dismiss()
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var publications: [Publication]
    EditPublicationView(publication: publications.first!)
}
