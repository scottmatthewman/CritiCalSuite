// The Swift Programming Language
// https://docs.swift.org/swift-book

import CoreLocation
import Foundation

@Observable
public class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<Void, Error>?

    public override init() {
        super.init()
        manager.delegate = self
    }

    public func requestPermission() async throws {
        switch manager.authorizationStatus {
        case .notDetermined:
            try await withCheckedThrowingContinuation { continuation in
                self.continuation = continuation
                manager.requestWhenInUseAuthorization()
            }
        case .restricted, .denied:
            throw LocationError.permissionDenied
        case .authorizedAlways, .authorizedWhenInUse:
            return
        @unknown default:
            throw LocationError.unknown
        }
    }

    public func locationManagerDidChangeAuthorization(
        _ manage: CLLocationManager
    ) {

    }
}

public enum LocationError: LocalizedError {
    case permissionDenied
    case unknown

    public var errorDescription: String? {
        switch self {
        case .permissionDenied:
            "Location access is required to calculate travel time"
        case .unknown:
            "Unable to access location"
        }
    }
}
