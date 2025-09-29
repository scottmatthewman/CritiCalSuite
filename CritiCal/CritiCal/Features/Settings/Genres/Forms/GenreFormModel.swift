//
//  GenreFormModel.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalCore
import Foundation

@Observable
class GenreFormModel {
    var name: String
    var details: String
    var colorToken: ColorToken
    var symbolName: String
    var isDeactivated: Bool

    init(
        name: String = "",
        details: String = "",
        colorToken: ColorToken = .tomato,
        symbolName: String = "theatermasks",
        isDeactivated: Bool = false
    ) {
        self.name = name
        self.details = details
        self.colorToken = colorToken
        self.symbolName = symbolName
        self.isDeactivated = isDeactivated
    }

    func stripName() {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValid: Bool {
        name.isEmpty == false
    }
}

