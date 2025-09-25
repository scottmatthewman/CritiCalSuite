//
//  OnboardingFlowModifier.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

/// View modifier for presenting the onboarding flow
public struct OnboardingFlowModifier: ViewModifier {
    @State private var settings: OnboardingSettings
    @State private var showOnboarding = false

    public init(settings: OnboardingSettings = OnboardingSettings()) {
        self._settings = State(initialValue: settings)
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                showOnboarding = settings.shouldShowOnboarding
            }
            #if os(iOS)
            .fullScreenCover(isPresented: $showOnboarding) {
                OnboardingFlowView {
                    settings.completeOnboarding()
                }
            }
            #else
            .sheet(isPresented: $showOnboarding) {
                OnboardingFlowView {
                    settings.completeOnboarding()
                }
                .frame(minWidth: 600, minHeight: 500)
            }
            #endif
    }
}

// MARK: - View Extension

public extension View {
    /// Present onboarding flow if needed based on version tracking
    func onboardingFlow(settings: OnboardingSettings = OnboardingSettings()) -> some View {
        modifier(OnboardingFlowModifier(settings: settings))
    }
}