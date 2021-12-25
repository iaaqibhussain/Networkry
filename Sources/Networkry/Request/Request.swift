//
//  Request.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public protocol Request {
    var host: String { get }
    var path: String { get }
    var requestType: RequestType { get }
}

extension Request {
    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }

    func request() throws -> URLRequest {
        guard let var components = URLComponents(string: host) else { throw NetworkError.invalidURL }
        components.path = path

        if !urlParams.isEmpty {
            components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }
        }

        guard let url = components.url else { throw  NetworkError.invalidURL }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}
