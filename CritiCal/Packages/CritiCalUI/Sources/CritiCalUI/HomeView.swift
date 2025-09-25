//
//  SwiftUIView.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 23/09/2025.
//

import SwiftUI

public struct HomeView: View {
    private var onSettingsSelected: () -> Void

    public init(
        onSettingsSelected: @escaping () -> Void
    ) {
        self.onSettingsSelected = onSettingsSelected
    }

    public var body: some View {
        NavigationStack {
            Group {
                ContentUnavailableView("Home", systemImage: "house")
            }
            .navigationTitle("CritiCal")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Settings", systemImage: "gearshape") {
                        onSettingsSelected()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeView {
            print("onSettingsSelected")
        }
    }
}
