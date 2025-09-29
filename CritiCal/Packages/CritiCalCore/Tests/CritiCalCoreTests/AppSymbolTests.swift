//
//  AppSymbolTests.swift
//  CritiCalCore
//
//  Created by Scott Matthewman on 25/09/2025.
//

import Testing
import Foundation
@testable import CritiCalCore

@Suite("AppSymbol")
struct AppSymbolTests {
    @Test
    func setsName() {
        let symbol = AppSymbol("theatermasks")

        #expect(symbol.name == "theatermasks")
    }
}
