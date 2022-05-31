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
                completion(.failure(.readError(error)))
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
                debugPrint("CoreDataResponseStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
}
