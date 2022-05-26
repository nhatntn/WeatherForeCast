//
//  QueriesStorage.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol QueriesStorage {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[WeatherForecastData], Error>) -> Void)
    func saveRecentQuery(query: String, completion: @escaping (Result<WeatherForecastData, Error>) -> Void)
}
