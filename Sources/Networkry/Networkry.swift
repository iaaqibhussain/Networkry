//
//  Networkry.swift
//
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public final class Networkry {
    private let apiManager: ApiManager
    private lazy var dataParser: DecodableDataParser = DecodableDataParserImpl()

    public convenience init() {
        self.init(apiManager: ApiManagerImpl())
    }

    public init(apiManager: ApiManager = ApiManagerImpl()) {
        self.apiManager = apiManager
    }

    public init(
        apiManager: ApiManager = ApiManagerImpl(),
        dataParser: DecodableDataParser = DecodableDataParserImpl()
    ) {
        self.apiManager = apiManager
        self.dataParser = dataParser
    }

    public func execute(
        with request: Request,
        completionHandler: @escaping (Result<Data, NetworkError>) -> ()
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

    public func addRequest(interceptor: Interceptor) {
        apiManager.addRequest(interceptor: interceptor)
    }
}
