//
//  EventIntentError.swift
//  CritiCalIntents
//
//  Created by Claude on 20/09/2025.
//

import Foundation

/// Errors that can occur during intent execution
public enum EventIntentError: Error, LocalizedError {
    case eventNotFound(id: UUID)
    case repositoryError(Error)
    case invalidTimeframe
    case parameterNotSet

    public var errorDescription: String? {
        switch self {
        case .eventNotFound(let id):
            return "Event with ID \(id) was not found."
        case .repositoryError(let error):
            return "Repository error: \(error.localizedDescription)"
        case .invalidTimeframe:
            return "Invalid timeframe specified."
        case .parameterNotSet:
            return "Required parameter was not set."
        }
    }

    public var failureReason: String? {
        switch self {
        case .eventNotFound:
            return "The specified event does not exist in the database."
        case .repositoryError:
            return "An error occurred while accessing the event database."
        case .invalidTimeframe:
            return "The timeframe parameter is not valid."
        case .parameterNotSet:
            return "A required parameter was not provided."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .eventNotFound:
            return "Please select a different event or check if the event still exists."
        case .repositoryError:
            return "Please try again later or contact support if the problem persists."
        case .invalidTimeframe:
            return "Please select a valid timeframe (today, past, or future)."
        case .parameterNotSet:
            return "Please provide all required parameters."
        }
    }
}