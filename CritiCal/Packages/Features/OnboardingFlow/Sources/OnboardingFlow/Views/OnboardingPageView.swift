//
//  OnboardingPageView.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

/// View for displaying a single onboarding page
struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: page.systemImage)
                .font(.system(size: 80))
                .foregroundStyle(page.imageColor.gradient)
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 16) {
                Text(page.title)
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                Text(page.description)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                if page.disclaimer.isEmpty == false {
                    Text(page.disclaimer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
