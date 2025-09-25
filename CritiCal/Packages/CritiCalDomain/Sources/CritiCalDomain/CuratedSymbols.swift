//
// CuratedSymbols.swift
// CritiCalDomain
//
// Created by Scott Matthewman on 24/09/2025.
//

import Foundation

public enum CuratedSymbols {
    public static let theatreAndStage = SymbolSection(
        title: "Theatre & Stage",
        symbols: [
            AppSymbol("theatermasks", keywords: ["theatre","drama","comedy","mask"]),
            AppSymbol("ticket", keywords: ["ticket","admit"]),
            AppSymbol("star", keywords: ["rating","favourite"]),
            AppSymbol("text.book.closed", keywords: ["script","playtext"]),
            AppSymbol("book", keywords: ["play","script"]),
            AppSymbol("curlybraces", keywords: ["monologue","dialogue"]),
            AppSymbol("bubble", keywords: ["monologue","dialogue"]),
            AppSymbol("quote.bubble", keywords: ["monologue","dialogue"]),
            AppSymbol("captions.bubble", keywords: ["monologue","dialogue"]),
            AppSymbol("star.bubble", keywords: ["rating","favourite"])
        ].dedup()
    )

    public static let musicAndDance = SymbolSection(
        title: "Music & Dance",
        symbols: [
            AppSymbol("music.note"),
            AppSymbol("music.mic"),
            AppSymbol("pianokeys"),
            AppSymbol("metronome"),
            AppSymbol("figure.dance"),
            AppSymbol("music.pages"),
            AppSymbol("music.note.tv"),
            AppSymbol("music.note.square.stack"),
            AppSymbol("microphone")
        ].dedup()
    )

    public static let peopleAndMasks = SymbolSection(
        title: "People & Masks",
        symbols: [
            AppSymbol("person"),
            AppSymbol("person.2"),
            AppSymbol("person.3"),
            AppSymbol("face.smiling"),
            AppSymbol("theatermasks.circle"),
            AppSymbol("figure.and.child.holdinghands", keywords: ["family","parent"]),
            AppSymbol("figure.2.and.child.holdinghands", keywords: ["family","parents"])
        ].dedup()
    )

    public static let timeAndCalendar = SymbolSection(
        title: "Time & Calendar",
        symbols: [
            AppSymbol("calendar"),
            AppSymbol("clock"),
            AppSymbol("hourglass"),
            AppSymbol("bookmark"),
            AppSymbol("bookmark.fill"),
        ].dedup()
    )

    public static let shapesAndBadges = SymbolSection(
        title: "Shapes & Badges",
        symbols: [
            AppSymbol("seal"),
            AppSymbol("seal.fill"),
            AppSymbol("circle"),
            AppSymbol("circle.fill"),
            AppSymbol("square"),
            AppSymbol("square.fill"),
            AppSymbol("hexagon"),
            AppSymbol("hexagon.fill"),
        ].dedup()
    )

    public static let allSections: [SymbolSection] = [
        theatreAndStage, musicAndDance, peopleAndMasks, timeAndCalendar, shapesAndBadges
    ]
}

private extension Array where Element == AppSymbol {
    func dedup() -> [AppSymbol] {
        var seen = Set<String>()
        return self.filter { seen.insert($0.name).inserted }
    }
}
