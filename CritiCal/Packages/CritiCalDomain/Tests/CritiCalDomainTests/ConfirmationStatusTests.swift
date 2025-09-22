//
//  Test.swift
//  CritiCalDomain
//
//  Created by Scott Matthewman on 21/09/2025.
//

import Foundation
import Testing
@testable import CritiCalDomain

//     case draft
//case tentative
//case bidForReview
//case awaitingConfirmation
//case confirmed
//case cancelled

@Suite("ConfirmationStatus - basic enum functionality")
struct ConfirmationStatusBasicTests {
    @Test(
        "ConfirmationStatus is initalizated from string values",
        arguments: [
            ("tentative", ConfirmationStatus.tentative),
            ("draft", ConfirmationStatus.draft),
            ("bidForReview", ConfirmationStatus.bidForReview),
            ("awaitingConfirmation", ConfirmationStatus.awaitingConfirmation),
            ("confirmed", ConfirmationStatus.confirmed),
            ("cancelled", ConfirmationStatus.cancelled)
        ]
    )
    func initializeFromRawValues(rawValue: String, expectedStatus: ConfirmationStatus) {
        let confirmed = ConfirmationStatus(rawValue: "confirmed")

        #expect(confirmed == .confirmed)
    }

    @Test("Does not initialize from invalid string values",
          arguments: ["invalid", "", "CONFIRMED", "123"])
    func doesNotInitializeFromInvalidRawValues(rawValue: String) {
        let status = ConfirmationStatus(rawValue: rawValue)
        #expect(status == nil)
    }

    @Test("All cases are present in allCases")
    func allCasesArePresent() {
        let allCases = Set(ConfirmationStatus.allCases)
        let expectedCases: Set<ConfirmationStatus> = [
            .draft,
            .tentative,
            .bidForReview,
            .awaitingConfirmation,
            .confirmed,
            .cancelled
        ]
        #expect(allCases == expectedCases)
    }
}

@Suite("ConfirmationStatus - Display Representation")
struct ConfirmationStatusDisplayRepresentationTests {
    @Test(
        "Localized displayName matches all values",
        arguments: [
            (ConfirmationStatus.draft, "Draft"),
            (ConfirmationStatus.tentative, "Tentative"),
            (ConfirmationStatus.bidForReview, "Bid for Review"),
            (ConfirmationStatus.awaitingConfirmation, "Awaiting Confirmation"),
            (ConfirmationStatus.confirmed, "Confirmed"),
            (ConfirmationStatus.cancelled, "Cancelled")
        ]
    )
    func testDisplayName(status: ConfirmationStatus, expectedName: String) {
        let displayName = String(localized: status.displayName)

        #expect(displayName == expectedName)
    }

    @Test(
        "Localized displayDescription matches all values",
        arguments: [
            (ConfirmationStatus.draft, "Details are started but may be incomplete"),
            (ConfirmationStatus.tentative, "There's a possibility this will happen"),
            (ConfirmationStatus.bidForReview, "The possibility of a review has been requested"),
            (ConfirmationStatus.awaitingConfirmation, "Waiting for confirmation from the event organiser"),
            (ConfirmationStatus.confirmed, "Attendance at this event has been confirmed"),
            (ConfirmationStatus.cancelled, "This event, or your attendance, has been cancelled")
        ]
    )
    func testDisplayName(status: ConfirmationStatus, expectedDescription: String) {
        let displayDescription = String(localized: status.displayDescription)

        #expect(displayDescription == expectedDescription)
    }
}

@Suite("ConfirmationStatus - computed collections")
struct ConfirmationStatusComputedCollectionsTests {
    @Test("isConfirmed collection includes only confirmed status")
    func testIsConfirmedCollection() {
        #expect(ConfirmationStatus.isConfirmed == [.confirmed])
    }

    @Test("isPending collection includes only intermediate statuses")
    func testIsPendingCollection() {
        #expect(ConfirmationStatus.isPending == [
            .draft, .tentative, .bidForReview, .awaitingConfirmation
        ])
    }

    @Test("isDraft collection includes only draft status")
    func testIsDraftCollection() {
        #expect(ConfirmationStatus.isDraft == [.draft])
    }

    @Test("isCancelled collection includes only cancelled status")
    func testIsCancelledCollection() {
        #expect(ConfirmationStatus.isCancelled == [.cancelled])
    }

    @Test("Only confirmed status returns true for isConfirmed()",
          arguments: [
            (ConfirmationStatus.draft, false),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, true),
            (ConfirmationStatus.cancelled, false)
          ])
    func testIsConfirmedMethod(status: ConfirmationStatus, expectedResult: Bool) {
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
    func testIsPendingMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isPending() == expectedResult, "Expected \(status) to return \(expectedResult) for isPending()")
    }

    @Test("Only draft status is true for isDraft()",
          arguments: [
            (ConfirmationStatus.draft, true),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, false),
            (ConfirmationStatus.cancelled, false)
          ])
    func testIsDraftMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isDraft() == expectedResult, "Expected \(status) to return \(expectedResult) for isDraft()")
    }

    @Test("Only cancelled status is true for isCancelled()",
          arguments: [
            (ConfirmationStatus.draft, false),
            (ConfirmationStatus.tentative, false),
            (ConfirmationStatus.bidForReview, false),
            (ConfirmationStatus.awaitingConfirmation, false),
            (ConfirmationStatus.confirmed, false),
            (ConfirmationStatus.cancelled, true)
          ])
    func testIsCancelledMethod(status: ConfirmationStatus, expectedResult: Bool) {
        #expect(status.isCancelled() == expectedResult, "Expected \(status) to return \(expectedResult) for isCancelled()")
    }
}

@Suite("ConfirmationStatus - Sendable")
struct ConfirmationStatusSendableTests {
    @Test("ConfirmationStatus conforms to Sendable protocol")
    func testSendableConformance() async {
        let confirmedStatus: ConfirmationStatus = .confirmed

        await withTaskGroup(of: ConfirmationStatus.self) { group in
            group.addTask { confirmedStatus }
            group.addTask { confirmedStatus }

            var results: [ConfirmationStatus] = []
            for await result in group {
                results.append(result)
            }

            #expect(results.count == 2)
            #expect(results.allSatisfy { $0 == .confirmed } )
        }
    }
}
