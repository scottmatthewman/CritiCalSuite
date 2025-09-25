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
            symbolName: genre.symbolName,
            isDeactivated: genre.isDeactivated
        )
    }
}

extension DetachedGenre {
    /// Convert GenreDTO to DetachedGenre for preview/test data
    init(genreDTO: GenreDTO) {
        self.init(
            id: genreDTO.id,
            name: genreDTO.name,
            details: genreDTO.details,
            colorName: "", // GenreDTO doesn't have colorName, so we'll use empty string
            hexColor: genreDTO.hexColor,
            symbolName: genreDTO.symbolName,
            isDeactivated: genreDTO.isDeactivated
        )
    }
}
