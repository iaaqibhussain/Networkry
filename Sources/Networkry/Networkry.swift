//
//  Networkry.swift
//
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public protocol NetworkryProtocol {
    func execute(
        with request: Request,
        completionHandler: @escaping DataCompletionHandler
    )

    func execute<T: Decodable>(
        with request: Request,
        completionHandler: @escaping (Result<T, NetworkError>) -> ()
    )
}

public final class Networkry: NetworkryProtocol {
    private let apiManager: ApiManager
    private let dataParser: DecodableDataParser

    static let shared: NetworkryProtocol = Networkry()

    private init(
        apiManager: ApiManager = ApiManagerImpl(),
        dataParser: DecodableDataParser = DecodableDataParserImpl()
    ) {
        self.apiManager = apiManager
        self.dataParser = dataParser
    }

    public func execute(
        with request: Request,
        completionHandler: @escaping DataCompletionHandler
    ) {
        apiManager.execute(
            with: request,
            completionHandler: completionHandler
        )
    }

    public func execute<T: Decodable>(
        with request: Request,
        completionHandler: @escaping (Result<T, NetworkError>) -> ()
    ) {
        apiManager.execute(with: request) { response in
            switch response {
            case let .success(data):
                do {
                    let parsed: T = try self.dataParser.parse(data: data)
                    completionHandler(.success(parsed))
                } catch {
                    completionHandler(.failure(.error(error)))
                }
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }
}
