//
//  WeatherForecastItem.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

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
    
    init(dateInterval: Double, pressure: Int, humidity: Int, weatherEntities: [WeatherEntity], temperature: TemperatureEntity) {
        self.dateInterval = dateInterval
        self.pressure = pressure
        self.humidity = humidity
        self.weatherItems = weatherEntities.map { $0.toInstance() }
        self.temperature = Temperature(day: temperature.day, min: temperature.min, max: temperature.max)
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
    
    init(day: Double, min: Double, max: Double) {
        self.day = day
        self.min = min
        self.max = max
    }
}

class Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
    
    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
