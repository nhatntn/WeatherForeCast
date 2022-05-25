//
//  Endpoint.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

public enum HTTPMethodType: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

public protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var queryParameters: [String: Any] { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol ResponseRequestable: Requestable {
    associatedtype Response
    
    var responseDecoder: ResponseDecoder { get }
}
