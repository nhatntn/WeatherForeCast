//
//  Repository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol Repository {
    func fetchList(query: String, cached: @escaping ([WeatherForecastItem]) -> Void,
                   completion: @escaping (Result<WeatherForecastData, DataRepositoryError>) -> Void) -> NetworkCancellable?
}

protocol IconRepository {
    func fetchImage(with iconPath: String,
                    completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable?
}
