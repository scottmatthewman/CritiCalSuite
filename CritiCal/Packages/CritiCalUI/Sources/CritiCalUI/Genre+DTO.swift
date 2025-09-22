import Foundation
import CritiCalDomain
import CritiCalModels

extension GenreDTO {
    init(genre: Genre) {
        self.init(
            id: genre.identifier ?? UUID(),
            name: genre.name,
            details: genre.details,
            hexColor: genre.hexColor,
            isDeactivated: genre.isDeactivated
        )
    }
}