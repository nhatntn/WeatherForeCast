//
//  DailyResponseDTO+Mapping.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 24/05/2022.
//

import Foundation

public struct DailyResponseDTO: Decodable {
    let data: WeatherForecastData?
    let error: ResponseError?
        
    enum ResponseKeys: String, CodingKey {
        case code = "cod"
    }
    
    public init(from decoder: Swift.Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseKeys.self)
        let code = try container.decode(String.self, forKey: .code)
        
        if code != "200" {
            self.error = try ResponseError(from: decoder)
            self.data = nil
            return
        }
        
        self.data = try WeatherForecastData.init(from: decoder)
        self.error = nil
    }
    
}
