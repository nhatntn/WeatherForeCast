//
//  SearchUseCaseTests.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import XCTest

class SearchUseCaseTests: XCTestCase {
    struct RepositoryMock: Repository {
        var result: Result<WeatherForecastData, NetworkError>
        
        func fetchList(query: String, cached: @escaping ([WeatherForecastItem]) -> Void,
                       completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable? {
            completion(result)
            return nil
        }
    }
    
    
}
