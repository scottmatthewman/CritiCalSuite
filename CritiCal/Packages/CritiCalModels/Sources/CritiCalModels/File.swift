//
//  File.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 10/10/2025.
//

import CritiCalCore
import CritiCalExtensions
import SwiftUI

public extension ColorToken {
    var color: Color {
        Color(hex: rawValue)
    }
}
