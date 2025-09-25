//
//  Genre+Samples.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 24/09/2025.
//

import Foundation

public extension Genre {
    static var sampleData: [Genre] {
        [
            Genre(
                name: "Musical Theatre",
                details: "A form of theatrical performance incolve acting, saning and dance",
                colorName: "tomato",
                hexColor: "#cc0000"
            ),
            Genre(
                name: "Cabaret",
                details: "Theatrical entertainment usually in small venues",
                colorName: "orange",
                hexColor: "#ff0000"
            ),
            Genre(
                name: "Dance",
                details: "An art form consisisting of purposeful movement, usually in synchronisation to music",
                colorName: "teal",
                hexColor: "#0033cc"
            ),
            Genre(
                name: "Opera",
                details: "Classical musical form, usually with no spoken dialogue and extragavant sets",
                colorName: "amber",
                hexColor: "#808040",
                isDeactivated: true
            )
        ]
    }
}
