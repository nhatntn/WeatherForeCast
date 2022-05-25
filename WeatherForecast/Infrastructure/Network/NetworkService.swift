//
//  NetworkService.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case invalidURL
    case invalidJSON
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

public protocol Networkable {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E,
                                                       completion: @escaping CompletionHandler) -> NetworkCancellable? where E.Response == T
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}


public final class NetworkService: Networkable {
    private let config: NetworkConfigurable
    
    public init(config: NetworkConfigurable) {
        self.config = config
    }
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
            case .notConnectedToInternet: return .notConnected
            case .cancelled: return .cancelled
            default: return .notConnected
        }
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request) { data, response, requestError in
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                completion(.failure(error))
            } else {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
    
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.invalidURL))
            return nil
        }
    }
    
    public func request<T, E>(with endpoint: E, completion: @escaping CompletionHandler) -> NetworkCancellable? where T : Decodable, T == E.Response, E : ResponseRequestable {
        return self.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                DispatchQueue.main.async { return completion(result) }
            case .failure(let error):
                let error = self.resolve(error: error)
                DispatchQueue.main.async { return completion(.failure(error)) }
            }
        }
    }
    
}
