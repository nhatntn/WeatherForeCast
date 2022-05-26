//
//  CoreDataResponseStorage.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation
import CoreData

final class CoreDataResponseStorage {
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    // MARK: - Private
    
    private func fetchRequest(for requestDto: DailyRequestDTO) -> NSFetchRequest<DailyRequestEntity> {
        let request: NSFetchRequest = DailyRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@",
                                        #keyPath(DailyRequestEntity.query), requestDto.q)
        return request
    }
    
    private func deleteResponse(for requestDto: DailyRequestDTO, in context: NSManagedObjectContext) {
        let request = fetchRequest(for: requestDto)
        
        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataResponseStorage: ResponseStorage {
    func getResponse(for requestDto: DailyRequestDTO, completion: @escaping (Result<[WeatherForecastItem]?, CoreDataStorageError>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDto)
                let requestEntity = try context.fetch(fetchRequest).first
                
                completion(.success(requestEntity?.response?.toData()))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(response responseDto: DailyResponseDTO, for requestDto: DailyRequestDTO) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(for: requestDto, in: context)

                let requestEntity = requestDto.toEntity(in: context)
                requestEntity.response = responseDto.toEntity(in: context)

                try context.save()
            } catch {
                debugPrint("CoreDataMoviesResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}

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
