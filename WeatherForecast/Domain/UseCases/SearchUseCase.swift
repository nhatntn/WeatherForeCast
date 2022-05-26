//
//  SearchUseCase.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol SearchUseCase {
    func execute(requestValue: String,
                 cached: @escaping ([WeatherForecastItem]) -> Void,
                 completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable?
}

final class DefaultSearchUseCase: SearchUseCase {
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func execute(requestValue: String, cached: @escaping ([WeatherForecastItem]) -> Void, completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable? {
        return self.repository.fetchList(query: requestValue, cached: cached) { result in
            completion(result)
        }
    }
    
}
