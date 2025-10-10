//
//  SampleDataProvider.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 24/09/2025.
//

import CritiCalModels
import Foundation
import SwiftData
import SwiftUI

public struct SampleDataProvider: PreviewModifier {
    public func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }

    public static func makeSharedContext() async throws -> ModelContainer {
        let container = try StoreFactory.makeContainer(cloud: false, inMemory: true)

        prepareSampleData(into: container.mainContext)

        return container
    }

    private static func prepareSampleData(into context: ModelContext) {
        let genres = Genre.sampleData
        genres.forEach { context.insert($0) }

        let publications = Publication.sampleData
        publications.forEach { context.insert($0) }

        let events = Event.sampleData(
            genres: genres,
            publications: publications
        )
        events.forEach { context.insert($0) }

        do {
            try context.save()
        } catch {
            print("Failed to save sample data: \(error.localizedDescription)")
        }
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    public static var sampleData: Self = .modifier(SampleDataProvider())
}
