//
//  SearchUseCase.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol SearchUseCase {
    func execute(requestValue: String,
                 cached: @escaping (String) -> Void,
                 completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable?
}

final class DefaultSearchUseCase: SearchUseCase {
    private let repository: Repository
    private let queriesRepository: QueriesRepository
    
    init(repository: Repository,
         queriesRepository: QueriesRepository) {
        
        self.repository = repository
        self.queriesRepository = queriesRepository
    }
    
    
    func execute(requestValue: String, cached: @escaping (String) -> Void, completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable? {
        return self.repository.fetchList(query: requestValue) { (_) in
            
        } completion: { result in
            if case .success = result {
                self.queriesRepository.saveRecentQuery(query: requestValue) { _ in }
            }

            completion(result)
        }

    }
    
    
}
