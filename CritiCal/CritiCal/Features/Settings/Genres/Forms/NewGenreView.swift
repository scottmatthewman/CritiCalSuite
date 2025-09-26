//
//  NewGenreView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 24/09/2025.
//

import CritiCalDomain
import CritiCalStore
import CritiCalUI
import SwiftUI

struct NewGenreView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var model = GenreFormModel()

    var body: some View {
        NavigationStack {
            GenreForm(model: model)
            .navigationTitle("New Genre")
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

        dismiss()
    }
}

#Preview(traits: .sampleData) {
    NewGenreView()
}
