//
//  SwiftUIView.swift
//  Setting
//
//  Created by Scott Matthewman on 24/09/2025.
//

import CritiCalCore
import CritiCalExtensions
import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

public struct GenresListView: View {
    @Namespace private var namespace

    @Query(
        filter: #Predicate<Genre> { $0.isDeactivated == false },
        sort: \Genre.name
    ) private var activeGenres: [Genre]
    @Query(
        filter: #Predicate<Genre> { $0.isDeactivated == true },
        sort: \Genre.name
    ) private var deactivatedGenres: [Genre]

    @State private var showNewGenre: Bool = false
    @State private var genreToEdit: Genre?

    public init() { }

    public var body: some View {
        List {
            Section {
                ForEach(activeGenres) { genre in
                    row(for: genre)
                }
            }
            if !deactivatedGenres.isEmpty {
                Section {
                    ForEach(deactivatedGenres) { genre in
                        row(for: genre)
                    }
                } header: {
                    Text("Deactivated Genres")
                } footer: {
                    Text("Deactivated genres will continue to show on relevant events' metadata, but will not be available to add to new events")
                }
            }
        }
        .navigationTitle("Genres")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Add a genre", systemImage: "plus") {
                    showNewGenre.toggle()
                }
                .matchedTransitionSource(id: "showNewGenre", in: namespace)
            }
        }
        .sheet(isPresented: $showNewGenre) {
            NewGenreView()
                .navigationTransition(
                    .zoom(sourceID: "showNewGenre", in: namespace)
                )
        }
        .sheet(item: $genreToEdit) { genre in
            EditGenreView(genre)
                .navigationTransition(
                    .zoom(sourceID: genre.identifier, in: namespace)
                )

        }
    }

    private func row(for genre: Genre) -> some View {
        Button {
            genreToEdit = genre
        } label: {
            GenreRow(genre: genre)
        }
        .foregroundStyle(.primary)
        .matchedTransitionSource(id: genre.identifier, in: namespace)
    }
}

extension Genre {
    var color: Color {
        if let colorToken = ColorToken(rawValue: colorName) {
            return colorToken.color
        } else {
            return Color(hex: hexColor)
        }
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        GenresListView()
    }
}
