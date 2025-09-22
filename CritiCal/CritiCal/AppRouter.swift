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
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                ContentUnavailableView("Home", systemImage: "house")
            }
            Tab("Events", systemImage: "theatermasks", value: .events) {
                NavigationStack(path: $router.eventsPath) {
                    EventListView()
                        .navigationDestination(for: NavigationRouter.EventTabRoute.self) { route in
                            switch route {
                            case .eventDetails(let id):
                                EventDetailView(id: id)
                            }
                        }
                }
            }
            Tab("Reviews", systemImage: "star.bubble", value: .reviews) {
                NavigationStack(path: $router.reviewsPath) {
                    ContentUnavailableView("Reviews", systemImage: "star.bubble")
                }
            }
            Tab(value: .search, role: .search) {
                ContentUnavailableView.search
            }
        }
        .onAppIntentExecution(OpenEventIntent.self) { intent in
            let eventID = intent.target.id
            router.navigate(toEvent: eventID)
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    AppRouter()
        .environment(NavigationRouter())
}
