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
    
    static func getIcon(with iconPath: String) -> Endpoint<DailyResponseDTO> {
        return Endpoint(path: iconPath,
                        method: .get,
                        responseDecoder: RawDataResponseDecoder())
    }
}
