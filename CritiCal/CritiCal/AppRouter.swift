//
//  AppRouter.swift
//  CritiCal
//
//  Created by Scott Matthewman on 20/09/2025.
//

import AppIntents
import CritiCalUI
import CritiCalIntents
import SwiftUI

struct AppRouter: View {
    enum Route: Hashable {
        case eventDetails(UUID)
    }

    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            EventListView {
                path.append(.eventDetails($0))
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .eventDetails(let id):
                    EventDetailView(id: id)
                }
            }
        }
        .onAppIntentExecution(OpenEventIntent.self) { intent in
            let eventID = intent.target.id
            path = [.eventDetails(eventID)]
        }
    }
}
