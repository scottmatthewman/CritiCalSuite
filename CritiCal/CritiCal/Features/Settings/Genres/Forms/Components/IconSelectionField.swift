//
//  IconSelectionField.swift
//  CritiCal
//
//  Created by Scott Matthewman on 25/09/2025.
//

import CritiCalCore
import SwiftUI

struct IconSelectionField: View {
    @Binding var selectedSymbol: String
    var columns: [GridItem]

    var body: some View {
        ForEach(CuratedSymbols.allSections) { section in
            VStack(alignment: .leading) {
                Text(section.title)
                    .font(.headline)
                LazyVGrid(columns: columns) {
                    ForEach(section.symbols) { symbol in
                        IconCell(
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

