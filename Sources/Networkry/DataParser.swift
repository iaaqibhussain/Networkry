//
//  DataParser.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

protocol DecodableDataParser {
    func parse<T: Decodable>(data: Data) throws -> T
}

final class DecodableDataParserImpl: DecodableDataParser {
    private let jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse<T: Decodable>(data: Data) throws -> T {
        try jsonDecoder.decode(T.self, from: data)
    }
}
