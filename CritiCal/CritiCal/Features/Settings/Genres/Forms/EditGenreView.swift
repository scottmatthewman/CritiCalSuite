//
//  EditGenreView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalCore
import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

struct EditGenreView: View {
    @Environment(\.dismiss) private var dismiss

    @State var model: GenreFormModel

    private var genre: Genre

    init(_ genre: Genre) {
        let genreModel = GenreFormModel(
            name: genre.name,
            details: genre.details,
            colorToken: ColorToken(rawValue: genre.colorName) ?? .amber,
            symbolName: genre.symbolName
        )
        self.genre = genre
        _model = State(initialValue: genreModel)
    }

    var body: some View {
        NavigationStack {
            GenreForm(model: model)
            .navigationTitle("Edit Genre")
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

    private func cancel() { dismiss() }
    private func save() {
        guard model.isValid else { return }

        genre.name = model.name
        genre.details = model.details
        genre.colorName = model.colorToken.rawValue
        genre.symbolName = model.symbolName
        genre.isDeactivated = model.isDeactivated

        dismiss()
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query(sort: \Genre.name) var genres: [Genre]
    EditGenreView(genres[0])
}
