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
            confirmationStatus: ConfirmationStatus(rawValue: event.confirmationStatusRaw ?? "draft") ?? .draft,
            url: event.url,
            details: event.details,
            genre: event.genre.map { GenreDTO(genre: $0) }
        )
    }
}
