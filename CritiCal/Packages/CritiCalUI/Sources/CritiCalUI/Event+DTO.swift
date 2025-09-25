import CritiCalDomain
import CritiCalModels

extension EventDTO {
    init(event: Event) {
        self.init(
            id: event.identifier,
            title: event.title,
            festivalName: event.festivalName,
            date: event.date,
            durationMinutes: event.durationMinutes,
            venueName: event.venueName,
            confirmationStatus: event.confirmationStatus,
            url: event.url,
            details: event.details,
            genre: event.genre.map { GenreDTO(genre: $0) }
        )
    }
}

extension DetachedEvent {
    /// Convert EventDTO to DetachedEvent for preview/test data
    init(eventDTO: EventDTO) {
        self.init(
            id: eventDTO.id,
            title: eventDTO.title,
            festivalName: eventDTO.festivalName,
            date: eventDTO.date,
            durationMinutes: eventDTO.durationMinutes,
            venueName: eventDTO.venueName,
            confirmationStatus: eventDTO.confirmationStatus,
            url: eventDTO.url,
            details: eventDTO.details,
            genre: eventDTO.genre.map { DetachedGenre(genreDTO: $0) }
        )
    }
}
