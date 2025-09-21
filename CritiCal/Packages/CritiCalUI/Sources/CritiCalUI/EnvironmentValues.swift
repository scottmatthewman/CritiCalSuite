//
//  EnvironmentValues.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalDomain

public extension EnvironmentValues {
    @Entry var eventReader: EventReading? = nil
    @Entry var eventWriter: EventWriting? = nil
}
