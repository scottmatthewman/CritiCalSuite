//
//  ShowEventIntent.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import AppIntents
import CritiCalStore
import CritiCalDomain

public struct ShowEventIntent: AppIntent {
    public static let title: LocalizedStringResource = "Show Event"
    public static let description = IntentDescription("Display detailed information about an event")

    @Parameter(title: "Event")
    var event: EventEntity

    public init() {}

    @MainActor
    public func perform() async throws -> some IntentResult & ReturnsValue<EventEntity> & ShowsSnippetView {
        // Return the event entity which will trigger the snippet view
        return .result(value: event, view: EventSnippetView(event: event))
    }
}
