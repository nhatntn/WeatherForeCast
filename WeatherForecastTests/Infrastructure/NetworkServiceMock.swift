//
//  NetworkServiceMock.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}

struct URLSessionManagerMock: URLSessionManageable {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
        return URLSession.shared.dataTask(with: request, completionHandler: completion)
    }
}

private struct EndpointMock: Requestable {
    var path: String
    var method: HTTPMethodType
    var queryParametersEncodable: Encodable?
    var queryParameters: [String: Any] = [:]
    
    init(path: String, method: HTTPMethodType) {
        self.path = path
        self.method = method
    }
    
    public func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: networkConfig)
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
