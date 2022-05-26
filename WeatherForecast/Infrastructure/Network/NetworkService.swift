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
    case invalidInput
    case generic(error: Error)
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
    private let urlSession: URLSessionManageable
    
    public init(config: NetworkConfigurable, urlSession: URLSessionManageable = URLSessionManager()) {
        self.urlSession = urlSession
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
        return urlSession.request(request) { data, response, requestError in
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

public protocol URLSessionManageable {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

public class URLSessionManager: URLSessionManageable {
    public init() {}
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}
