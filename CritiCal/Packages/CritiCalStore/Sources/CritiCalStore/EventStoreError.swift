//
//  EventStoreError.swift
//  CritiCalStore
//
//  Created by Scott Matthewman on 21/09/2025.
//

public enum EventStoreError: Error {
    case notFound
    case saveFailed(Error)
    case deleteFailed(Error)
}

