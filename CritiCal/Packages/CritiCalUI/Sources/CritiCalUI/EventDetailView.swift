//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import CritiCalModels
import CritiCalStore
import SwiftData
import SwiftUI

public struct EventDetailView: View {
    @Bindable var event: Event

    public init(event: Event) {
        self.event = event
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        if let genre = event.genre {
                            Label(genre.name, systemImage: genre.symbolName)
                                .labelStyle(.tag)
                                .tint(genre.color)
                        }
                        if !event.festivalName.isEmpty {
                            Text(event.festivalName)
                                .font(.caption)
                                .foregroundStyle(.tint)
                        }
                    }
                    Text(event.title)
                        .font(.title.bold())
                }
                .scenePadding(.horizontal)
                VStack(alignment: .leading, spacing: 8) {
                    Text(
                        event.date ..< event.endDate,
                        format: .interval
                            .weekday(.wide)
                            .month().day().year()
                            .hour().minute()
                    )
                    Text(
                        Duration.seconds(event.date.distance(to: event.endDate)),
                        format: .units(allowed: [.hours, .minutes], width: .abbreviated)
                    )
                    .foregroundStyle(.secondary)
                    if event.confirmationStatus.isConfirmed() == false {
                        Label(
                            event.confirmationStatus.displayName,
                            systemImage: event.confirmationStatus.systemImage
                        )
                        .labelStyle(.tag)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                .scenePadding(.horizontal)
                .contentShape(.rect)
                .contextMenu {
                    Picker("Change status", selection: $event.confirmationStatus) {
                        ForEach(event.confirmationStatus.nextActions) { action in
                            Label(
                                action.actionDisplayName,
                                systemImage: action.systemImage
                            )
                            .tag(action)
                        }
                    }
                    Button("Edit", systemImage: "pencil.line") { }
                }
                Divider()

                EventMapDetails(event: event)
                    .scenePadding(.horizontal)

                Divider()

                VStack(alignment: .leading) {
                    if let url = event.url {
                        Link(destination: url) {
                            LabeledContent {
                                Text(url.trimmedHost ?? url.absoluteString)
                            } label: {
                                Label("Website", systemImage: "globe")
                            }
                        }
                    }

                    if event.details.isEmpty == false {
                        Text(event.details)
                            .lineSpacing(4.0)
                    }
                }
                .scenePadding(.horizontal)
            }

            
        }
        .listStyle(.plain)
        .navigationTitle("Event")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview(traits: .sampleData) {
    @Previewable @Query var events: [Event]
    NavigationStack {
        EventDetailView(event: events[0])
    }
}
