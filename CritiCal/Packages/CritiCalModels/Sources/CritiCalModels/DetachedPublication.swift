//
//  DetachedPublication.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 08/10/2025.
//

import CritiCalCore
import CritiCalExtensions
import Foundation
import SwiftUI

public struct DetachedPublication: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let name: String
    nonisolated public let details: String
    nonisolated public let colorName: String
    nonisolated public let typicalWordCount: Int?
    nonisolated public let typicalFee: Int?
    nonisolated public let awardsStars: Bool
    nonisolated public let isDeactivated: Bool

    nonisolated public init(
        id: UUID,
        name: String,
        details: String,
        colorName: String,
        typicalWordCount: Int?,
        typicalFee: Int?,
        awardsStars: Bool,
        isDeactivated: Bool
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.colorName = colorName
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
        self.isDeactivated = isDeactivated
    }

    public var color: Color {
        if let colorToken = ColorToken(rawValue: colorName) {
            return colorToken.color
        }
        return Color.accentColor
    }
}

public extension Publication {
    func detached() -> DetachedPublication {
        DetachedPublication(
            id: identifier ?? UUID(),
            name: name,
            details: details,
            colorName: colorName,
            typicalWordCount: typicalWordCount,
            typicalFee: typicalFee,
            awardsStars: awardsStars,
            isDeactivated: isDeactivated
        )
    }
}
