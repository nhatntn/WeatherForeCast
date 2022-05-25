//
//  API.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

struct APIEndpoints {
    static func getDailyWeatherForecast(with query: DailyRequestDTO) -> Endpoint<DailyResponseDTO> {
        return Endpoint(path: "forecast/daily",
                        method: .get,
                        queryParametersEncodable: query)
    }
}
