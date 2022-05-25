//
//  DefaultRepository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

final class DefaultRepository {
    
    private let networkService: Networkable
    private let cache: ResponseStorage
    
    init(networkService: Networkable, cache: ResponseStorage) {
        self.networkService = networkService
        self.cache = cache
    }
}

extension DefaultRepository: Repository {
    public func fetchList(query: String, cached: @escaping (String) -> Void,
                          completion: @escaping (Result<String, Error>) -> Void) -> NetworkCancellable? {
        return nil
    }
}
