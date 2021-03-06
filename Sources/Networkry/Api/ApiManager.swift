//
//  ApiManager.swift
//  
//
//  Created by Aaqib Hussain on 19.12.21.
//

import Foundation

public protocol Interceptor {
    func addInterceptor(request: URLRequest) -> URLRequest
}

public protocol ApiManager {
    func execute(
        with request: Request,
        completionHandler: @escaping (Result<Data, NetworkError>) -> ()
    )

    func addRequest(interceptor: Interceptor)
}

public final class ApiManagerImpl: ApiManager {
    private let urlSession: URLSession
    private var interceptor: Interceptor?

    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    public func execute(
        with request: Request,
        completionHandler: @escaping (Result<Data, NetworkError>) -> ()
    ) {
        do {
            let request = try request.request()
            let interceptedRequest = interceptor?.addInterceptor(request: request) ?? request
            let task = dataTask(request: interceptedRequest, completionHandler: completionHandler)
            task.resume()
        } catch {
            completionHandler(.failure(.error(error)))
        }
    }

    public func addRequest(interceptor: Interceptor) {
        self.interceptor = interceptor
    }
}

private extension ApiManagerImpl {
    func dataTask(
        request: URLRequest,
        completionHandler: @escaping (Result<Data, NetworkError>) -> ()
    ) -> URLSessionDataTask {
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
