//
//  TravelTimeView.swift
//  CritiCalMaps
//
//  Created by Scott Matthewman on 12/10/2025.
//

import CritiCalSettings
import MapKit
import SwiftUI

public struct TravelTimeView: View {
    private let destination: MKMapItem

    @ReadOnlySetting(.preferredTransitMode) private var transitMode

    @State private var travelTime: TimeInterval?
    @State private var locationError: Error?
    @State private var locationManager = LocationManager()

    public init(
        destination: MKMapItem
    ) {
        self.destination = destination
    }

    public var body: some View {
        TravelTimeLabel(
            travelTime: travelTime,
            transitMode: transitMode,
            locationError: locationError
        )
        .task {
            await calculateTravelTime()
        }
    }
    
    private func calculateTravelTime() async {
        do {
            // Request location permission if needed
            try await locationManager.requestPermission()
            
            let request = MKDirections.Request()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = destination
            request.transportType = transitMode.mapKitTransportType
            
            let directions = MKDirections(request: request)
            let response = try await directions.calculateETA()
            travelTime = response.expectedTravelTime
            locationError = nil
        } catch {
            locationError = error
            travelTime = nil
        }
    }
}
