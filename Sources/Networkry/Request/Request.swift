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

public extension Request {

    public var params: [String: Any] {
        [:]
    }

    public var urlParams: [String: String?] {
        [:]
    }

    public var headers: [String: String] {
        [:]
    }

    public var includeInterceptor: Bool {
        true
    }

    func request() throws -> URLRequest {
        guard var components = URLComponents(string: host) else { throw NetworkError.invalidURL }
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
