//
//  WeatherForecaseInfo.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 24/05/2022.
//

import Foundation

class WeatherForecastInfo: Codable {
    let listItems: [WeatherForecastItem]
    var expiryTime: TimeInterval?
    
    enum WeatherForecastInfoKeys: String, CodingKey {
        case listItems = "list"
        case expiryTime = "expiry_time"
    }
    
    required init(from decoder: Swift.Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: WeatherForecastInfoKeys.self)
        self.listItems = try parentContainer.decode([WeatherForecastItem].self, forKey: .listItems)
        self.expiryTime = try parentContainer.decodeIfPresent(TimeInterval.self, forKey: .expiryTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WeatherForecastInfoKeys.self)
        try container.encode(self.listItems, forKey: .listItems)
        try container.encode(self.expiryTime, forKey: .expiryTime)
    }
}

class WeatherForecastItem: Codable {
    let dateInterval: TimeInterval
    let pressure: Int
    let humidity: Int
    let weatherItems: [Weather]
    let temperature: Temperature
    
    enum WeatherForecastItemKeys: String, CodingKey {
        case dateInterval = "dt"
        case pressure
        case humidity
        case weather
        case temperature = "temp"
    }
    
    required init(from decoder: Swift.Decoder) throws {
        let parentContainer = try decoder.container(keyedBy: WeatherForecastItemKeys.self)
        self.dateInterval = try parentContainer.decode(TimeInterval.self, forKey: .dateInterval)
        self.pressure = try parentContainer.decode(Int.self, forKey: .pressure)
        self.humidity = try parentContainer.decode(Int.self, forKey: .humidity)
        self.weatherItems = try parentContainer.decode([Weather].self, forKey: .weather)
        self.temperature = try parentContainer.decode(Temperature.self, forKey: .temperature)
    }
        
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: WeatherForecastItemKeys.self)
        try container.encode(self.dateInterval, forKey: .dateInterval)
        try container.encode(self.pressure, forKey: .pressure)
        try container.encode(self.humidity, forKey: .humidity)
        try container.encode(self.weatherItems, forKey: .weather)
        try container.encode(self.temperature, forKey: .temperature)
      }

}

class Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
}

class Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
