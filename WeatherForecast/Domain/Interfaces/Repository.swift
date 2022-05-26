//
//  Repository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol Repository {
    @discardableResult
    func fetchList(query: String, cached: @escaping ([WeatherForecastItem]) -> Void,
                   completion: @escaping (Result<WeatherForecastData, NetworkError>) -> Void) -> NetworkCancellable?
}
