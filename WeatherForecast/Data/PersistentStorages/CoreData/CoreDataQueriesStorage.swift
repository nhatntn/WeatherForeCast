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
