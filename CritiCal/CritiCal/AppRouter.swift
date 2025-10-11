//
//  AppRouter.swift
//  CritiCal
//
//  Created by Scott Matthewman on 20/09/2025.
//

import AppIntents
import AppSettings
import CritiCalUI
import CritiCalIntents
import CritiCalStore
import OnboardingFlow
import SwiftUI

struct AppRouter: View {
    @Environment(NavigationRouter.self) private var router
    @State private var onboardingSettings = OnboardingSettings()

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            Tab("Home", systemImage: "house", value: .home) {
                HomeView()
            }
            Tab("Events", systemImage: "theatermasks", value: .events) {
                NavigationStack(path: $router.eventsPath) {
                    EventListView { eventID in
                        router.navigate(toEvent: eventID)
                    }
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
            Tab("Developer", systemImage: "hammer", value: .developer) {
                DeveloperView()
            }
            Tab(value: .search, role: .search) {
                ContentUnavailableView.search
            }
        }
        .onAppIntentExecution(OpenEventIntent.self) { intent in
            let eventID = intent.target.id
            router.navigate(toEvent: eventID)
        }
        .sheet(isPresented: $router.isSettingsViewPresented) {
            SettingsView()
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onboardingFlow(settings: onboardingSettings)
    }
}

#Preview(traits: .sampleData) {
    AppRouter()
        .environment(NavigationRouter())
}
