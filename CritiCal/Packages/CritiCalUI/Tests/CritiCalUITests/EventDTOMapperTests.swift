import Foundation
import Testing
import CritiCalDomain
import CritiCalModels
@testable import CritiCalUI

@Suite("EventDTO mapping")
struct EventDTOMapperTests {
    @Test("builds DTO from SwiftData model")
    func buildsDTOFromModel() {
        let event = Event(
            identifier: UUID(uuidString: "00000000-0000-0000-0000-000000000123")!,
            title: "Preview Night",
            festivalName: "Edinburgh Fringe",
            venueName: "Pleasance",
            date: .iso8601("2025-08-10T19:30:00Z"),
            durationMinutes: 95,
            confirmationStatusRaw: ConfirmationStatus.confirmed.rawValue
        )

        let dto = EventDTO(event: event)

        #expect(dto.id == event.identifier)
        #expect(dto.title == event.title)
        #expect(dto.festivalName == event.festivalName)
        #expect(dto.venueName == event.venueName)
        #expect(dto.date == event.date)
        #expect(dto.durationMinutes == event.durationMinutes)
        #expect(dto.confirmationStatus == ConfirmationStatus.confirmed)
    }

    @Test("defaults to draft status when raw value missing")
    func defaultsToDraftStatus() {
        let event = Event(
            identifier: UUID(uuidString: "00000000-0000-0000-0000-000000000456")!,
            title: "Tech Rehearsal",
            festivalName: "",
            venueName: "Donmar",
            date: .iso8601("2025-08-09T10:00:00Z"),
            durationMinutes: nil,
            confirmationStatusRaw: nil
        )

        let dto = EventDTO(event: event)

        #expect(dto.confirmationStatus == ConfirmationStatus.draft)
    }
}
