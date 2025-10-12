//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

public struct EventDetailViewByID: View {
    @Query private var events: [Event]
    public let id: UUID

    public init(id: UUID) {
        self.id = id
        _events = Query(filter: #Predicate<Event> { $0.identifier == id })
    }

    public var body: some View {
        Group {
            if let event = events.first {
                EventDetailView(event: event)
            } else {
                ProgressView("Loading…")
            }
        }
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var events: [Event]
    NavigationStack {
        EventDetailViewByID(id: events[0].identifier)
    }
}
