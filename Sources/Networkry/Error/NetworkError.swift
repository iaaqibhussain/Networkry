//
//  NetworkError.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public enum NetworkError: LocalizedError {
    case invalidServerResponse
    case invalidURL
    case error(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case let .error(err):
            return err.localizedDescription
        }
    }
}
