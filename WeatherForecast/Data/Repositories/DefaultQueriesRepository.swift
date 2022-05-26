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
