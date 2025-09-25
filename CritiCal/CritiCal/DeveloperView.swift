//
//  DeveloperView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 23/09/2025.
//

import OnboardingFlow
import SwiftUI

struct DeveloperView: View {
    @State private var onboardingResetAlert: Bool = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Reset onboarding flow", systemImage: "slider.horizontal.2.arrow.trianglehead.counterclockwise", action: resetOnboarding)
                        .alert(
                            "Onboarding reset",
                            isPresented: $onboardingResetAlert
                        ) {
                            Button("Done", role: .cancel) { }
                        } message: {
                            Text("All onboarding data has been reset. You will need to manually shut down the app and restart to see the onboarding flow.")
                        }

                }
            }
            .navigationTitle("Developer")
        }
    }

    private func resetOnboarding() {
        let settings = OnboardingSettings()
        settings.resetOnboarding()
        onboardingResetAlert = true
    }
}

#Preview {
    DeveloperView()
}
