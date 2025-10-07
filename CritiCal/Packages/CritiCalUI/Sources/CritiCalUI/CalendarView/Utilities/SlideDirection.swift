//
//  SlideDirection.swift
//  CritiCalUI
//
//  Created by Scott Matthewman on 05/10/2025.
//

import SwiftUI

internal enum SlideDirection {
    case forward
    case backward
}

internal extension AnyTransition {
    static func calendarSlide(direction: SlideDirection, isRTL: Bool) -> AnyTransition {
        let insertion: Edge
        let removal: Edge
        switch direction {
        case .forward:
            insertion = isRTL ? .leading : .trailing
            removal = isRTL ? .trailing : .leading
        case .backward:
            insertion = isRTL ? .trailing : .leading
            removal = isRTL ? .leading : .trailing
        }
        return .asymmetric(
            insertion: .move(edge: insertion).combined(with: .opacity),
            removal: .move(edge: removal).combined(with: .opacity)
        )
    }
}

func horizontalPagingGesture(
    threshold: CGFloat = 40,
    onPrevious: @escaping () -> Void,
    onNext: @escaping () -> Void
) -> some Gesture {
    DragGesture(minimumDistance: threshold / 2)
        .onEnded { value in
            let dx = value.translation.width
            let dy = value.translation.height
            guard abs(dx) > abs(dy),
                    abs(dx) > threshold
            else { return }

            if dx < 0 {
                onNext()
            } else {
                onPrevious()
            }
        }
}
