//
//  File.swift
//  CritiCalIntents
//
//  Created by Scott Matthewman on 18/09/2025.
//

import AppIntents
import CritiCalDomain
import CritiCalStore

public struct GetEventIntent: AppIntent {
    static public let title: LocalizedStringResource = "Get Event"
    static public let description = IntentDescription("Fetch an event by choosing it from your events")

    @Parameter(title: "Event") var event: EventEntity

    public init() { }

    public func perform() async throws -> some IntentResult & ReturnsValue<EventEntity> & ProvidesDialog {
        let repo = try await SharedStores.eventRepo()
        _ = try await repo.event(byIdentifier: event.id)
        return .result(value: event, dialog: "Fetched \(event.title).")
    }
}


