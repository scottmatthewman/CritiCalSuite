//
//  PublicationFormModel.swift
//  CritiCal
//
//  Created by Scott Matthewman on 09/10/2025.
//

import CritiCalModels
import SwiftUI

@Observable
class PublicationFormModel {
    var name: String
    var colorToken: ColorToken
    var isDeactivated: Bool

    var urlString: String
    var details: String
    var typicalWordCount: Int?
    var typicalFee: Int?
    var awardsStars: Bool

    init(
        name: String = "",
        details: String = "",
        colorToken: ColorToken = .tomato,
        isDeactivated: Bool = false,
        urlString: String = "",
        typicalWordCount: Int? = nil,
        typicalFee: Int? = nil,
        awardsStars: Bool = true
    ) {
        self.name = name
        self.details = details
        self.colorToken = colorToken
        self.isDeactivated = isDeactivated
        self.urlString = urlString
        self.typicalWordCount = typicalWordCount
        self.typicalFee = typicalFee
        self.awardsStars = awardsStars
    }

    func stripName() {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var color: Color {
        colorToken.color
    }

    var isValid: Bool {
        name.isEmpty == false
    }
}
