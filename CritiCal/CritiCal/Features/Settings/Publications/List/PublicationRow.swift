//
//  PublicationRow.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import CritiCalModels
import CritiCalStore
import CritiCalUI
import SwiftData
import SwiftUI

struct PublicationRow: View {
    var publication: Publication

    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(publication.name)
                HStack(alignment: .firstTextBaseline, spacing: 20) {
                    if let typicalWordCount = publication.typicalWordCount {
                        Label("\(typicalWordCount) words", systemImage: "text.rectangle")
                    }
                    if let typicalFee = publication.typicalFee {
                        Label(
                            typicalFee
                                .formatted(
                                    .currency(code: "GBP")
                                    .precision(.fractionLength(0))
                                ),
                            systemImage: "banknote"
                        )
                    }
                    Label(publication.awardsStars ? "Awards stars" : "No stars", systemImage: "star.bubble")
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .labelIconToTitleSpacing(8)
            }
        } icon: {
            CircularIcon(systemImage: "newspaper")
                .tint(publication.color)
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query(sort: \Publication.name) var publications: [Publication]

    NavigationStack {
        List(publications, rowContent: PublicationRow.init)
    }
}
