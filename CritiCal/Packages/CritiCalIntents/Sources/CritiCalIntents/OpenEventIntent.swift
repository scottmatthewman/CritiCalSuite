//
//  OpenEventIntent.swift
//  CritiCalIntents
//
//  Created by Claude on 21/09/2025.
//

import AppIntents

public struct OpenEventIntent: OpenIntent {
    public static let title: LocalizedStringResource = "Open Event"
    public static let description = IntentDescription("Open an event in the app to view its details")

    // This tells the system to open the app when the intent runs
    public static let openAppWhenRun: Bool = true

    // OpenIntent conformance - target must be a URLRepresentableEntity
    @Parameter(title: "Event")
    public var target: EventEntity

    public init() {}

    public init(event: EventEntity) {
        self.target = event
    }
}


#if os(iOS)
extension OpenEventIntent: TargetContentProvidingIntent {}
#endif
