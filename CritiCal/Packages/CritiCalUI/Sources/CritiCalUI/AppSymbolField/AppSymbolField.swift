//
//  AppSymbolField.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalModels
import SwiftUI

public struct AppSymbolField: View {
    @Binding private var selectedSymbol: String
    private var columns: [GridItem]

    public init(
        selectedSymbol: Binding<String>,
        columns: [GridItem]
    ) {
        self._selectedSymbol = selectedSymbol
        self.columns = columns
    }

    public var body: some View {
        ForEach(CuratedSymbols.allSections) { section in
            VStack(alignment: .leading) {
                Text(section.title)
                    .font(.headline)
                LazyVGrid(columns: columns) {
                    ForEach(section.symbols) { symbol in
                        AppSymbolCell(
                            name: symbol.name,
                            selected: selectedSymbol == symbol.name
                        ) {
                            selectedSymbol = symbol.name
                        }
                        .frame(width: 44, height: 44)
                    }
                }
            }
        }

    }
}

