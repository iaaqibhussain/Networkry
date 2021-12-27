//
//  DecodableDataParser.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public protocol DecodableDataParser {
    func parse<T: Decodable>(data: Data) throws -> T
}

public final class DecodableDataParserImpl: DecodableDataParser {
    private let jsonDecoder: JSONDecoder

    public init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    public func parse<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}
