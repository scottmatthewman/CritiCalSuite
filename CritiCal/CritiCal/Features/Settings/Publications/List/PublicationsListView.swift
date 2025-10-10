//
//  PublicationsListView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import CritiCalCore
import CritiCalExtensions
import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

struct PublicationsListView: View {
    @Namespace private var namespace

    @Query(
        filter: #Predicate<Publication> { $0.isDeactivated == false },
        sort: \Publication.name
    ) private var activePublications: [Publication]
    @Query(
        filter: #Predicate<Publication> { $0.isDeactivated == true },
        sort: \Publication.name
    ) private var deactivatedPublications: [Publication]

    @State private var showNewPublication: Bool = false
    @State private var publicationToEdit: Publication?

    var body: some View {
        List {
            Section {
                ForEach(activePublications) { publication in
                    row(for: publication)
                }
            }
            Section("Deactivated publications") {
                ForEach(deactivatedPublications) { publication in
                    row(for: publication)
                }
            }
        }
        .navigationTitle("Publications")
        .toolbar(content: toolbarContent)
        .sheet(isPresented: $showNewPublication) {
            NewPublicationView()
                .navigationTransition(
                    .zoom(sourceID: "showNewPublication", in: namespace)
                )
        }
        .sheet(item: $publicationToEdit) { publication in
            EditPublicationView(publication: publication)
                .navigationTransition(
                    .zoom(sourceID: publication.identifier, in: namespace)
                )
        }
    }

    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add a publication", systemImage: "plus") {
                showNewPublication.toggle()
            }
            .matchedTransitionSource(id: "showNewPublication", in: namespace)
        }
    }

    private func row(for publication: Publication) -> some View {
        Button {
            publicationToEdit = publication
        } label: {
            PublicationRow(publication: publication)
        }
        .foregroundStyle(.primary)
        .matchedTransitionSource(id: publication.identifier, in: namespace)
    }
}

#Preview(traits: .sampleData) {
    NavigationStack {
        PublicationsListView()
    }
}
