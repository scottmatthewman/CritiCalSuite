//
//  DetachedPublication.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 08/10/2025.
//

import Foundation
import SwiftUI
import CritiCalExtensions

public struct DetachedPublication: Identifiable, Equatable, Sendable {
    nonisolated public let id: UUID
    nonisolated public let name: String
//    public let details: String
//    public let colorName: String
    nonisolated public let hexColor: String
    nonisolated public let typicalWordCount: Int?
    nonisolated public let typicalFee: Int?
    nonisolated public let awardsStars: Bool
    nonisolated public let isDeactivated: Bool

    nonisolated public init(
        id: UUID,
        name: String,
//        details: String,
//        colorName: String,
        hexColor: String,
        typicalWordCount: Int?,
        typicalFee: Int?,
        awardsStars: Bool,
        isDeactivated: Bool
    ) {
        self.id = id
        self.name = name
//        self.details = details
//        self.colorName = colorName
        self.hexColor = hexColor
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
        self.isDeactivated = isDeactivated
    }

    nonisolated public var color: Color {
        Color(hex: hexColor)
    }
}

public extension Publication {
    func detached() -> DetachedPublication {
        DetachedPublication(
            id: identifier ?? UUID(),
            name: name,
            hexColor: hexColor,
            typicalWordCount: typicalWordCount,
            typicalFee: typicalFee,
            awardsStars: awardsStars,
            isDeactivated: isDeactivated
        )
    }
}
