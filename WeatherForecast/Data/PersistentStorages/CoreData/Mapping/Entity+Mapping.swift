//
//  Entity+Mapping.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

extension DailyResponseEntity {
    func toData() -> [WeatherForecastItem] {
        let weatherForecastEntities = self.items?.allObjects.compactMap{($0 as? WeatherForecastEntity)} ?? []
        return weatherForecastEntities.map {
            $0.toInstance()
        }
    }
}

extension WeatherForecastEntity {
    func toInstance() -> WeatherForecastItem {
        let weatherEntities = self.weathers?.allObjects.compactMap{($0 as? WeatherEntity)} ?? []
        let temperature = self.temperature!
        return WeatherForecastItem(dateInterval: self.dateInterval,
                                   pressure: Int(self.pressure),
                                   humidity: Int(self.humidity),
                                   weatherEntities: weatherEntities,
                                   temperature: temperature)
    }
}

extension WeatherEntity {
    func toInstance() -> Weather {
        return Weather(id: Int(self.id),
                       main: self.main ?? "",
                       description: self.detail ?? "",
                       icon: self.icon ?? "")
    }
}

extension TemperatureEntity {
    func toInstance() -> Temperature {
        return Temperature(day: self.day, min: self.min, max: self.max)
    }
}
