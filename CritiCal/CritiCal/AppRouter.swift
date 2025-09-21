//
//  AppRouter.swift
//  CritiCal
//
//  Created by Scott Matthewman on 20/09/2025.
//

import SwiftUI
import CritiCalUI

struct AppRouter: View {
    enum Route: Hashable {
        case eventDetails(UUID)
    }

    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            ContentView()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .eventDetails(let id):
                    EventDetailView(id: id)
                }
            }
        }
    }
}
