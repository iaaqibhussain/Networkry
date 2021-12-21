//
//  ApiManager.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public typealias DataCompletionHandler = (Result<Data, NetworkError>) -> ()

protocol ApiManager {
    func execute(
        with request: Request,
        completionHandler: @escaping DataCompletionHandler
    )
}

final class ApiManagerImpl: ApiManager {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func execute(
        with request: Request,
        completionHandler: @escaping DataCompletionHandler
    ) {
        do {
            let request = try request.request()
            dataTask(request: request, completionHandler: completionHandler)
        } catch {
            completionHandler(.failure(.error(error)))
        }
    }
}

private extension ApiManagerImpl {
    func dataTask(
        request: URLRequest,
        completionHandler: @escaping DataCompletionHandler
    ) {
        urlSession.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { completionHandler(.failure(NetworkError.invalidServerResponse))
                      return
                  }
            if let error = error {
                completionHandler(.failure(.error(error)))
                return
            }

            if let data = data {
                completionHandler(.success(data))
            }
        }
    }
}
