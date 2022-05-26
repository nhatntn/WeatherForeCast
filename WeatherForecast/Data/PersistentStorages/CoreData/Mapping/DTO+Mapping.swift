//
//  DTO+Mapping.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation
import CoreData

extension DailyRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> DailyRequestEntity {
        let entity: DailyRequestEntity = .init(context: context)
        entity.query = q
        return entity
    }
}

extension DailyResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> DailyResponseEntity {
        let entity: DailyResponseEntity = .init(context: context)
        self.data?.listItems.forEach {
            entity.addToItems($0.toEntity(in: context))
        }
        return entity
    }
}

extension WeatherForecastItem {
    func toEntity(in context: NSManagedObjectContext) -> WeatherForecastEntity {
        let entity: WeatherForecastEntity = .init(context: context)
        entity.dateInterval = self.dateInterval
        entity.humidity = Int32(self.humidity)
        entity.pressure = Int32(self.pressure)
        self.weatherItems.forEach {
            entity.addToWeathers($0.toEntity(in: context))
        }
        entity.temperature = self.temperature.toEntity(in: context)
        return entity
    }
}

extension Weather {
    func toEntity(in context: NSManagedObjectContext) -> WeatherEntity {
        let entity: WeatherEntity = .init(context: context)
        entity.id = Int32(self.id)
        entity.main = self.main
        entity.detail = self.description
        entity.icon = self.icon
        return entity
    }
}

extension Temperature {
    func toEntity(in context: NSManagedObjectContext) -> TemperatureEntity {
        let entity: TemperatureEntity = .init(context: context)
        entity.day = self.day
        entity.min = self.min
        entity.max = self.max
        return entity
    }
}
