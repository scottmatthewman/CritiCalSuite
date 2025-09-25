//
//  OnboardingFlowView.swift
//  OnboardingFlow
//
//  Created by Scott Matthewman on 22/09/2025.
//

import SwiftUI

/// Main coordinator view for the onboarding flow
public struct OnboardingFlowView: View {
    @State private var currentPageIndex = 0
    @Environment(\.dismiss) private var dismiss

    private let pages: [OnboardingPage]
    private let onComplete: () -> Void

    public init(
        pages: [OnboardingPage] = OnboardingPage.defaultPages,
        onComplete: @escaping () -> Void
    ) {
        self.pages = pages
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Skip button
            HStack {
                Spacer()
                Button("Skip") {
                    completeOnboarding()
                }
                .foregroundStyle(.secondary)
            }
            .padding()

            // Page content
            TabView(selection: $currentPageIndex) {
                ForEach(Array(pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(.page(indexDisplayMode: .never))
            #endif
            .animation(.easeInOut(duration: 0.3), value: currentPageIndex)

            // Page indicator and navigation
            VStack(spacing: 24) {
                // Custom page indicator
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPageIndex ? Color.accentColor : Color.secondary.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .animation(.easeInOut(duration: 0.3), value: currentPageIndex)
                    }
                }

                // Navigation buttons
                HStack(spacing: 16) {
                    // Previous button
                    if currentPageIndex > 0 {
                        Button {
                            withAnimation {
                                currentPageIndex -= 1
                            }
                        } label: {
                            Label("Previous", systemImage: "chevron.left")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }

                    // Next/Get Started button
                    Button {
                        if isLastPage {
                            completeOnboarding()
                        } else {
                            withAnimation {
                                currentPageIndex += 1
                            }
                        }
                    } label: {
                        Group {
                            if isLastPage {
                                Text("Get Started")
                            } else {
                                Label("Next", systemImage: "chevron.right")
                                    .labelStyle(.trailingIcon)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 24)
        }
        #if os(iOS)
        .navigationBarHidden(true)
        #endif
        .interactiveDismissDisabled()
    }

    private var isLastPage: Bool {
        currentPageIndex >= pages.count - 1
    }

    private func completeOnboarding() {
        onComplete()
        dismiss()
    }
}

// MARK: - Label Style

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: TrailingIconLabelStyle {
        TrailingIconLabelStyle()
    }
}

// MARK: - Preview

#Preview {
    OnboardingFlowView {
        print("Onboarding completed")
    }
}