//
//  Publication.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 08/10/2025.
//

import Foundation
import SwiftData
import SwiftUI
import CritiCalCore
import CritiCalExtensions

@Model
public final class Publication {
    public var identifier: UUID?
    public var name: String = ""
    public var details: String = ""
    public var colorName: String = "gray"

    public var url: URL?
    public var typicalWordCount: Int?
    public var typicalFee: Int?
    public var awardsStars: Bool = true
    public var isDeactivated: Bool = false

    @Relationship
    public var events: [Event]?

    public init(
        identifier: UUID? = UUID(),
        name: String,
        details: String,
        colorName: String,
        url: URL? = nil,
        typicalWordCount: Int? = nil,
        typicalFee: Int? = nil,
        awardsStars: Bool,
        isDeactivated: Bool
    ) {
        self.identifier = identifier
        self.name = name
        self.details = details
        self.colorName = colorName
        self.url = url
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
        self.isDeactivated = isDeactivated
    }

    public var colorToken: ColorToken {
        ColorToken(rawValue: colorName) ?? .gray
    }

    @MainActor
    public var color: Color {
        colorToken.color
    }
}
