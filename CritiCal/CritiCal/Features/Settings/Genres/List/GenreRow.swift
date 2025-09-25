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
            Circle()
                .frame(width: 44, height: 44)
                .foregroundStyle(.tint.quaternary)
                .overlay(
                    Image(systemName: "theatermasks")
                        .resizable()
                        .scaledToFit()
                        .padding(4)
                        .foregroundStyle(.tint)
                )
        }
        .labelStyle(.tintedIcon)
        .tint(genre.color)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query(sort: \Genre.name) var genres: [Genre]

    NavigationStack {
        List(genres, rowContent: GenreRow.init)
    }
}
