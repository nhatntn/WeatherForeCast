//
//  QueriesRepository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol QueriesRepository {
    func fetchRecentsQueries(maxCount: Int, completion: @escaping (Result<[String], Error>) -> Void)
    func saveRecentQuery(query: String, completion: @escaping (Result<String, Error>) -> Void)
}
