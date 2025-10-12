//
//  File.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import Foundation
#if canImport(UIKit)
import UIKit
#endif

extension DirectionsProvider {
    var canBeUsedForDirections: Bool {
        switch self {
        case .transit: canUseTransit
        default: true
        }
    }

    /// Determine in Transit is installed by registration of the custom URL.
    ///
    /// `transit` must be listed in info.plist in the
    /// ``LSApplicationQueriesSchemes`` array for this lookup to function.
    /// Transit is a UIKit-only app, so other platforms will automatically
    /// default to `false`
    private var canUseTransit: Bool {
#if canImport(UIKit)
        if let url = URL(string: "transit://directions"),
           UIApplication.shared.canOpenURL(url) {
            return true
        }
#endif
        return false
    }
}
