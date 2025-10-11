//
//  NavigationLink.swift
//  CritiCalExtensions
//
//  Created by Scott Matthewman on 11/10/2025.
//

import SwiftUI

public extension NavigationLink where Label == SwiftUI.Label<Text, Image> {
    init(
        _ title: LocalizedStringKey,
        systemImage: String,
        destination: () -> Destination
    ) {
        self = NavigationLink(destination: destination) {
            Label(title, systemImage: systemImage)
        }
    }
}

