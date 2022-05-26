//
//  WeatherForecastData.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

class WeatherForecastData: Codable {
    let listItems: [WeatherForecastItem]

    enum WeatherForecastInfoKeys: String, CodingKey {
        case listItems = "list"
    }
    
    required init(from decoder: Swift.Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: WeatherForecastInfoKeys.self)
        self.listItems = try parentContainer.decode([WeatherForecastItem].self, forKey: .listItems)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WeatherForecastInfoKeys.self)
        try container.encode(self.listItems, forKey: .listItems)
    }
}
