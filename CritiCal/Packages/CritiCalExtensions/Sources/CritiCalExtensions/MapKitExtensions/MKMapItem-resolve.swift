//
//  MKMapItem-resolve.swift
//  CritiCalExtensions
//
//  Created by Scott Matthewman on 11/10/2025.
//

@preconcurrency import MapKit

extension MKMapItem {
    public static func resolve(id stringIdentifier: String?) async -> MKMapItem? {
        guard let stringIdentifier,
              stringIdentifier.isEmpty == false,
              let mkIdentifier = MKMapItem.Identifier(
                rawValue: stringIdentifier
              )
        else { return nil }

        let request = MKMapItemRequest(mapItemIdentifier: mkIdentifier)
        let mapItem = try? await request.mapItem
        return mapItem
    }
}
