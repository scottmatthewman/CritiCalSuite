//
//  Event+Samples.swift
//  CritiCalModels
//
//  Created by Scott Matthewman on 25/09/2025.
//

import Foundation

public extension Event {
    @MainActor
    static var sampleData: [Event] {
        let titles = ["A Midsummer Night's Dream", "Hamlet", "Romeo and Juliet", "Macbeth", "The Tempest"]
        let venues: [String: String] = [
            "ID0ADE784CB355FCF": "Theatre Royal Drury Lane",
            "IB7D452C1A76F3C89": "The London Palladium",
            "ID222E15FEA96DA20": "The Royal Opera House",
            "IF85C965EC56E638": "Shaftesbury Theatre"
        ]

        let calendar = Calendar.current
        let baseDate = calendar.date(bySettingHour: 19, minute: 30, second: 0, of: .now)!

        let genres = Genre.sampleData
        
        return titles.enumerated().map { index, title in
            let event = Event(title: title)
            event.date = calendar.date(byAdding: .day, value: index * 4, to: baseDate)!
            event.durationMinutes = 105
            event.festivalName = "London Theatre Festival"
            event.genre = genres.randomElement()
            event.confirmationStatus = ConfirmationStatus.allCases.randomElement()!
            if let venueID = venues.keys.randomElement() {
                event.venueName = venues[venueID, default: "Unknown Venue"]
//                event.venueIdentifier = venueID
            }

            // Add lead photo with specified probabilities
//            let hasPhoto = Bool.random()
//            if hasPhoto {
//                let imageName = Bool.random() ? "Demo Landscape" : "Demo Portrait"
//                event.leadPhoto = createDemoImageAttachment(name: imageName)
//            }

            return event
        }

    }
}
