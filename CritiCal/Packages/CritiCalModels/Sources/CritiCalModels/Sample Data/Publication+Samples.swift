//
//  Publication+Samples.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 09/10/2025.
//

import Foundation

public extension Publication {
    @MainActor
    static var sampleData: [Publication] {
        [
            Publication(
                name: "Daily Mail",
                details: "Right-wing tabloid rag",
                colorName: "blue",
                typicalWordCount: 350,
                typicalFee: 75,
                awardsStars: true,
                isDeactivated: true
            ),
            Publication(
                name: "The Stage",
                details: "Industry newspaper",
                colorName: "teal",
                typicalWordCount: 400,
                typicalFee: 50,
                awardsStars: true,
                isDeactivated: false
            ),
            Publication(
                name: "Musical Theatre Review",
                details: "In-depth coverage of all things musical",
                colorName: "indigo",
                typicalWordCount: 650,
                typicalFee: nil,
                awardsStars: true,
                isDeactivated: false
            ),
            Publication(
                name: "The Reviews Hub",
                details: "National coverage of theatre, film and much more",
                colorName: "purple",
                typicalWordCount: 500,
                typicalFee: nil,
                awardsStars: true,
                isDeactivated: false
            ),
        ]
    }
}
