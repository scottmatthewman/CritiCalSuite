//
//  URL+Display.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 23/09/2025.
//

import Foundation

public extension URL {
    var trimmedHost: String? {
        guard let host else { return nil }

        if host.hasPrefix("www.") {
            return String(host.dropFirst(4))
        } else {
            return host
        }
    }
}
