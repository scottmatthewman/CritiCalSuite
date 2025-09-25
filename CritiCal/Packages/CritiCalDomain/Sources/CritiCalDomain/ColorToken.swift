//
//  ColorToken.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 24/09/2025.
//

import SwiftUI

public enum ColorToken: String, CaseIterable, Identifiable, Codable {
    case tomato   = "#E94635"
    case coral    = "#FA7364"
    case orange   = "#FF9400"
    case amber    = "#FFB022"
    case yellow   = "#FECF17"
    case lime     = "#C8E728"
    case green    = "#24BD67"
    case teal     = "#2BB6A6"
    case cyan     = "#1DA8D9"
    case blue     = "#2970E5"
    case indigo   = "#4A52DE"
    case purple   = "#9245DB"
    case magenta  = "#D7388F"
    case pink     = "#F56299"
    case brown    = "#8C664A"
    case gray     = "#8895A4"
    case slate    = "#5B6978"
    case black    = "#000000"

    public var id: String { rawValue }
}
