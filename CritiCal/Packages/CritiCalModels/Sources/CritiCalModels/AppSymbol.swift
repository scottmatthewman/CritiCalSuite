//
//  AppSymbol.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 24/09/2025.
//

import Foundation

public struct AppSymbol: Identifiable, Hashable, Sendable {
    public let name: String          // SF Symbol name, e.g. "theatermasks"
    public let keywords: [String]    // for search

    public init(_ name: String, keywords: [String] = []) {
        self.name = name
        self.keywords = keywords
    }

    public var id: String { name }
}

public struct SymbolSection: Identifiable, Sendable {
    public let id: UUID
    public let title: String
    public let symbols: [AppSymbol]

    init(title: String, symbols: [AppSymbol]) {
        self.id = UUID()
        self.title = title
        self.symbols = symbols
    }
}
