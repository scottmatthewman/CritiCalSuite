//
//  GenreRow.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalModels
import CritiCalStore
import CritiCalUI
import SwiftData
import SwiftUI

struct GenreRow: View {
    var genre: Genre

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(genre.name)
                    .font(.headline)
                if !genre.details.isEmpty {
                    Text(genre.details)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
        } icon: {
            CircularIcon(systemImage: genre.symbolName)
                .foregroundStyle(.tint)
                .background(.tint.quaternary, in: .circle)
                .tint(genre.color.gradient)
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query(sort: \Genre.name) var genres: [Genre]

    NavigationStack {
        List(genres, rowContent: GenreRow.init)
    }
}
