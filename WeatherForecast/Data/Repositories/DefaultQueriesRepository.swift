//
//  DefaultQueriesRepository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

final class DefaultQueriesRepository {
    
    private let networkService: Networkable
    private var queriesPersistentStorage: QueriesStorage
    
    init(networkService: Networkable,
         persistentStorage: QueriesStorage) {
        self.networkService = networkService
        self.queriesPersistentStorage = persistentStorage
    }
}

extension DefaultQueriesRepository: QueriesRepository {
    
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        
    }
    
    func saveRecentQuery(query: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        
    }
}
