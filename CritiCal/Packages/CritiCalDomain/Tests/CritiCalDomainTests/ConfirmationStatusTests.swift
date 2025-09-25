//
//  ConfirmationStatusTests.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 21/09/2025.
//

import Testing
@testable import CritiCalDomain

@Suite("ConfirmationStatus - Basic Properties")
struct ConfirmationStatusBasicTests {

    @Test("All status cases are present")
    func testAllCasesPresent() {
        let allCases = ConfirmationStatus.allCases
        #expect(allCases.contains(.draft))
        #expect(allCases.contains(.tentative))
        #expect(allCases.contains(.bidForReview))
        #expect(allCases.contains(.awaitingConfirmation))
        #expect(allCases.contains(.confirmed))
        #expect(allCases.contains(.cancelled))
        #expect(allCases.count == 6)
    }

    @Test("Raw values are correct")
    func testRawValues() {
        #expect(ConfirmationStatus.draft.rawValue == "draft")
        #expect(ConfirmationStatus.tentative.rawValue == "tentative")
        #expect(ConfirmationStatus.bidForReview.rawValue == "bidForReview")
        #expect(ConfirmationStatus.awaitingConfirmation.rawValue == "awaitingConfirmation")
        #expect(ConfirmationStatus.confirmed.rawValue == "confirmed")
        #expect(ConfirmationStatus.cancelled.rawValue == "cancelled")
    }
}

@Suite("ConfirmationStatus - Computed methods")
struct ConfirmationStatusMethodTests {

    @Test("Only confirmed status returns true for isConfirmed()",
          arguments: [
            (ConfirmationStatus.draft, false),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, true),
            (ConfirmationStatus.cancelled, false)
          ])
    @MainActor func testIsConfirmedMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isConfirmed() == expectedResult, "Expected \(status) to return \(expectedResult) for isConfirmed()")
    }

    @Test("All in progress actions return true for isPending()",
          arguments: [
            (ConfirmationStatus.draft, true),
            (ConfirmationStatus.tentative, true),
            (ConfirmationStatus.bidForReview, true),
            (ConfirmationStatus.awaitingConfirmation, true),
            (ConfirmationStatus.confirmed, false),
            (ConfirmationStatus.cancelled, false)
          ])
    @MainActor func testIsPendingMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isPending() == expectedResult, "Expected \(status) to return \(expectedResult) for isPending()")
    }

    @Test("Only draft status returns true for isDraft()",
          arguments: [
            (ConfirmationStatus.draft, true),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, false),
            (ConfirmationStatus.cancelled, false)
          ])
    @MainActor func testIsDraftMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isDraft() == expectedResult, "Expected \(status) to return \(expectedResult) for isDraft()")
    }

    @Test("Only cancelled status returns true for isCancelled()",
          arguments: [
            (ConfirmationStatus.draft, false),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, false),
            (ConfirmationStatus.cancelled, true)
          ])
    @MainActor func testIsCancelledMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isCancelled() == expectedResult, "Expected \(status) to return \(expectedResult) for isCancelled()")
    }
}