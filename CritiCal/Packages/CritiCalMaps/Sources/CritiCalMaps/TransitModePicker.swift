//
//  TransitModePicker.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import SwiftUI
import CritiCalSettings

/// Settings view for preferred transit mode
public struct TransitModePicker: View {
    private var title: LocalizedStringKey
    @Binding private var transitMode: TransitMode

    public init(
        _ title: LocalizedStringKey = "Transit mode",
        transitMode: Binding<TransitMode>
    ) {
        self.title = title
        self._transitMode = transitMode
    }

    public var body: some View {
        Picker(title, selection: $transitMode) {
            ForEach(TransitMode.allCases, id: \.self) { mode in
                Label(mode.displayName, systemImage: mode.symbolName)
                    .tag(mode)
            }
        }
    }
}

#Preview {
    @Previewable @State var transitMode: TransitMode = .cycling
    Form {
        TransitModePicker(transitMode: $transitMode)
    }
}
