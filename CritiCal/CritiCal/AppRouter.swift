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
import CritiCalModels
import CritiCalNavigation
import CritiCalStore
import OnboardingFlow
import SwiftData
import SwiftUI

struct AppRouter: View {
    @Environment(\.modelContext) private var modelContext
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
                    EventListView()
                        .navigationDestination(for: NavigationRouter.EventTabRoute.self) { route in
                            switch route {
                            case .event(let event):
                                EventDetailView(event: event)
                            case .eventByIdentifier(let id):
                                EventDetailViewByID(id: id)
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
            Task { await resolve(eventID: eventID) }
        }
        .sheet(isPresented: $router.isSettingsViewPresented) {
            SettingsView()
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .onboardingFlow(settings: onboardingSettings)
    }

    private func resolve(eventID: UUID) async {
        do {
            var descriptor = FetchDescriptor<Event>(
                predicate: #Predicate { $0.identifier == eventID }
            )
            descriptor.fetchLimit = 1
            if let event = try modelContext.fetch(descriptor).first {
                router.navigate(to: event)
            } else {
                router.navigate(toEventID: eventID)
            }
        } catch {
            router.navigate(toEventID: eventID)
        }
    }
}

#Preview(traits: .sampleData) {
    AppRouter()
        .environment(NavigationRouter())
}
