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
//    public var details: String = ""
    public var hexColor: String = "8888"
//    public var colorName: String = "gray"
//    public var symbolName: String = "theatermasks"

    var typicalWordCount: Int?
    var typicalFee: Int?
    var awardsStars: Bool = true
    var isDeactivated: Bool = false

    @Relationship
    public var events: [Event]?

    init(
        identifier: UUID? = UUID(),
        name: String,
        details: String,
        hexColor: String,
//        colorName: String,
//        symbolName: String,
        typicalWordCount: Int? = nil,
        typicalFee: Int? = nil,
        awardsStars: Bool,
        isDeactivated: Bool
    ) {
        self.identifier = identifier
        self.name = name
//        self.details = details
        self.hexColor = hexColor
//        self.colorName = colorName
//        self.symbolName = symbolName
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
        self.isDeactivated = isDeactivated
    }

    public var color: Color {
        Color(hex: hexColor)
    }

//    public var colorToken: ColorToken {
//        ColorToken(rawValue: colorName) ?? .blue
//    }
}
