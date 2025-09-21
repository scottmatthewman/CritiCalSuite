//
//  ContentView.swift
//  CritiCal
//
//  Created by Scott Matthewman on 18/09/2025.
//

import SwiftUI
import SwiftData
import CritiCalModels

struct ContentView: View {
    @Query(sort: [SortDescriptor(\Event.date, order: .reverse)]) var events: [Event]

    var body: some View {
        NavigationStack {
            List(events) { event in
                VStack(alignment: .leading) {
                    HStack(alignment: .firstTextBaseline) {
                        VStack(alignment: .leading) {
                            Text(event.title)
                                .font(.headline)
                            Text(event.venueName)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(event.date, style: .date)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Events")
        }
    }
}

#Preview {
    ContentView()
}
