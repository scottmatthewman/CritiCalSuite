//
//  DetachedPublication.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 08/10/2025.
//

import CritiCalExtensions
import Foundation
import SwiftUI

public struct DetachedPublication: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let name: String
    nonisolated public let details: String
    nonisolated public let colorToken: ColorToken
    nonisolated public let typicalWordCount: Int?
    nonisolated public let typicalFee: Int?
    nonisolated public let awardsStars: Bool
    nonisolated public let isDeactivated: Bool

    nonisolated public init(
        id: UUID,
        name: String,
        details: String,
        colorToken: ColorToken,
        typicalWordCount: Int?,
        typicalFee: Int?,
        awardsStars: Bool,
        isDeactivated: Bool
    ) {
        self.id = id
        self.name = name
        self.details = details
        self.colorToken = colorToken
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
        self.isDeactivated = isDeactivated
    }

    public var color: Color {
        colorToken.color
    }
}

public extension Publication {
    func detached() -> DetachedPublication {
        DetachedPublication(
            id: identifier ?? UUID(),
            name: name,
            details: details,
            colorToken: .cyan,
            typicalWordCount: typicalWordCount,
            typicalFee: typicalFee,
            awardsStars: awardsStars,
            isDeactivated: isDeactivated
        )
    }
}
