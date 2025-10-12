//
//  HomeView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 26/09/2025.
//

import CritiCalNavigation
import SwiftUI

struct HomeView: View {
    @Environment(NavigationRouter.self) private var router

    @State private var showSettings: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Today")
                            .font(.title.bold())
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.teal.gradient)
                            .frame(height: 240)
                    }
                    .padding(.vertical)

                    HStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.primary, .yellow)
                        VStack(alignment: .leading) {
                            Text("You have **35** past events marked as needing review, but don’t yet have a review recorded.")
                            Button("Manage reviews") { }
                                .bold()
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial, in: .rect(cornerRadius: 12))

                    HStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.title)
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(.yellow, .primary)
                        VStack(alignment: .leading) {
                            Text("You have **7** future events that have yet to be confirmed")
                            Button("Manage events") { }
                                .bold()
                        }
                    }
                    .padding(8)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.regularMaterial, in: .rect(cornerRadius: 12))

                    let colors: [Color] = [
                        .blue,
                        .brown,
                        .cyan,
                        .purple,
                        .orange,
                        .teal,
                        .indigo,
                        .cyan,
                        .purple,
                        .teal,
                        .yellow
                    ]
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Coming up")
                            .font(.title.bold())
                        ForEach(Array(colors.enumerated()), id: \.offset) { (offset, color) in
                            RoundedRectangle(cornerRadius: 24)
                                .fill(color.gradient)
                                .frame(height: 120)
                        }
                    }
                    .padding(.vertical)
                }
                .scenePadding(.horizontal)
            }
            .navigationTitle("CritiCal")
            .toolbarTitleDisplayMode(.inlineLarge)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Settings", systemImage: "gearshape") {
                        router.showSettings()
                    }
                }
            }

        }
    }
}

#Preview {
    HomeView()
        .environment(NavigationRouter())
}
