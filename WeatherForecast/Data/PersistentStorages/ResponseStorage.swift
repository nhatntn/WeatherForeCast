//
//  ResponseStorage.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol ResponseStorage {
    func getResponse(for request: DailyRequestDTO, completion: @escaping (Result<[WeatherForecastItem]?, CoreDataStorageError>) -> Void)
    func save(response responseDto: DailyResponseDTO, for requestDto: DailyRequestDTO)
}
