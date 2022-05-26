//
//  CoreDataQueriesStorage.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation
import CoreData

final class CoreDataQueriesStorage {

    private let maxStorageLimit: Int
    private let coreDataStorage: CoreDataStorage

    init(maxStorageLimit: Int, coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.maxStorageLimit = maxStorageLimit
        self.coreDataStorage = coreDataStorage
    }
}

extension CoreDataQueriesStorage: QueriesStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[WeatherForecastData], Error>) -> Void) {
        
    }
    
    func saveRecentQuery(query: String, completion: @escaping (Result<WeatherForecastData, Error>) -> Void) {

    }
}
