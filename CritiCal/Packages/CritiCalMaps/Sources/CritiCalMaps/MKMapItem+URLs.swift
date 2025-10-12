//
//  MKMapItem+URLs.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import MapKit

extension MKMapItem {
    var citymapperURL: URL? {
        guard var components = URLComponents(string: "https://citymapper.com/directions") else { return nil }
        let location = location
        let coordinate = location.coordinate

        components.queryItems = [
            URLQueryItem(name: "endcoord", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "endname", value: self.name ?? ""),
            URLQueryItem(name: "endaddress", value: getFullAddress() ?? "")
        ]

        return components.url
    }

    func googleMapsURL(mode: TransitMode?) -> URL? {
        guard var components = URLComponents(string: "https://www.google.com/maps/dir/") else { return nil }
        let coordinate = location.coordinate

        components.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "destination", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "travelmode", value: mode?.googleMapsMode)
        ]

        return components.url
    }

    var transitURL: URL? {
        guard
            var components = URLComponents(string: "transit://directions")
        else { return nil }
        let coordinate = location.coordinate

        components.queryItems = [
            URLQueryItem(name: "to", value: "\(coordinate.latitude),\(coordinate.longitude)")
        ]

        return components.url
    }

    private func getFullAddress(singleLine: Bool = true) -> String? {
        guard let representations = addressRepresentations else { return nil }

        return representations.fullAddress(
            includingRegion: true,
            singleLine: singleLine
           )
    }
}
