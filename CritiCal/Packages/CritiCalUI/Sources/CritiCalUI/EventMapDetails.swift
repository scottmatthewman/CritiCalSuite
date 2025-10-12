//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 11/10/2025.
//

import CritiCalExtensions
import CritiCalModels
import CritiCalStore
import MapKit
import SwiftData
import SwiftUI

enum MapLoadingState {
    case loading
    case loaded(MKMapItem)
    case notFound
}

public struct EventMapDetails: View {
    private let event: Event
    @State private var loadingState: MapLoadingState = .loading
    @State private var mapItemToShow: MKMapItem?

    public init(event: Event) {
        self.event = event
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(event.venueName)
                .font(.headline)
            switch loadingState {
            case .loading:
                loadingView()
            case .loaded(let mkMapItem):
                resolvedView(mapItem: mkMapItem)
            case .notFound:
                errorView()
            }
        }
        .task { await resolve() }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func resolve() async {
        if let mapItem = await MKMapItem.resolve(id: event.venueIdentifier) {
            loadingState = .loaded(mapItem)
        } else {
            loadingState = .notFound
        }
    }

    func loadingView() -> some View {
        VStack(alignment: .leading) {
            Text("One-line address of the theatre")
                .font(.subheadline)
                .redacted(reason: .placeholder)
            Text("venue-website.com")
                .foregroundStyle(.tint)
                .font(.subheadline)
                .redacted(reason: .placeholder)
            ProgressView()
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .background(.quaternary)
                .clipShape(.rect(cornerRadius: 20))
        }
    }

    func resolvedView(mapItem: MKMapItem) -> some View {
        VStack(alignment: .leading) {
            if let representations = mapItem.addressRepresentations,
               let address = representations.fullAddress(
                includingRegion: true,
                singleLine: true
               ) {
                Text(address)
                    .font(.subheadline)
                    .foregroundStyle(.primary)
            }
            if let url = mapItem.url, let host = url.trimmedHost {
                Link(host, destination: url)
                    .font(.subheadline)
            }
            Map(initialPosition: .item(mapItem), interactionModes: []) {
                Marker(item: mapItem)
                    .tag(mapItem)
            }
            .frame(height: 160)
            .clipShape(.rect(cornerRadius: 20))

        }
    }

    func errorView() -> some View {
        VStack(alignment: .leading) {
            Text("One-line address of the theatre")
                .font(.subheadline)
                .redacted(reason: .placeholder)
            Text("venue-website.com")
                .foregroundStyle(.tint)
                .font(.subheadline)
                .redacted(reason: .placeholder)
            RoundedRectangle(cornerRadius: 20)
                .fill(.quaternary)
                .frame(height: 160)
                .frame(maxWidth: .infinity)
                .overlay(
                    ContentUnavailableView("Not found", systemImage: "exclamationmark.triangle")
                )
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var events: [Event]

    ScrollView {
        VStack {
            EventMapDetails(event: events[0])
        }
        .padding()
    }
    .defaultScrollAnchor(.center)
}
