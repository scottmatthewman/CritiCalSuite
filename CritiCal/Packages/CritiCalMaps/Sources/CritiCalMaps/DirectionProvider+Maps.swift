//
//  DirectionProvider+Maps.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import Foundation
import SwiftUI
import MapKit

extension DirectionsProvider {
    internal func open(
        destination mapItem: MKMapItem,
        mode: TransitMode,
        openURL: OpenURLAction
    ) {
        switch self {
        case .appleMaps:
            mapItem.openInMaps(
                launchOptions: [MKLaunchOptionsDirectionsModeKey: mode.appleMapsDirectionsMode]
            )
        case .citymapper:
            if let citymapperURL = mapItem.citymapperURL {
                openURL(citymapperURL)
            }
        case .googleMaps:
            if let googleMapsURL = mapItem.googleMapsURL(mode: mode) {
                openURL(googleMapsURL)
            }
        case .transit:
            if let transitURL = mapItem.transitURL {
                openURL(transitURL) { accepted in
                    if !accepted {
                        print("Could not open in Transit")
                    }
                }
            }
        }
    }
}
