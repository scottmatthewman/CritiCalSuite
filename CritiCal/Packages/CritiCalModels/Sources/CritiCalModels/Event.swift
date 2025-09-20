//
//  Event.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftData
import Foundation

@Model
public final class Event {
    #Index<Event>([\.title], [\.date])

    public var identifier: UUID = UUID()
    @Attribute(.preserveValueOnDeletion) public var title: String = ""
    @Attribute(.preserveValueOnDeletion) public var date: Date = Date.now
    public var venueName: String = ""

    public init(
        identifier: UUID = UUID(),
        title: String = "",
        venueName: String = "",
        date: Date = Date.now

    ) {
        self.identifier = identifier
        self.title = title
        self.venueName = venueName
        self.date = date
    }
}
