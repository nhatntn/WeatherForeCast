//
//  DefaultRepository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

final class DefaultRepository {
    private let networkService: Networkable
    private let cache: ResponseStorage
    
    init(networkService: Networkable, cache: ResponseStorage) {
        self.networkService = networkService
        self.cache = cache
    }
}

public enum DataRepositoryError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case invalidInput
}

extension DefaultRepository: Repository {
    public func fetchList(query: String, cached: @escaping ([WeatherForecastItem]) -> Void,
                          completion: @escaping (Result<WeatherForecastData, DataRepositoryError>) -> Void) -> NetworkCancellable? {
        if query.count < 3 {
            completion(.failure(.invalidInput))
            return nil
        }
        
        let requestDTO = DailyRequestDTO(q: query, cnt: 7, units: "metric")
        var task: NetworkCancellable?
        let endpoint = APIEndpoints.getDailyWeatherForecast(with: requestDTO)
        
        cache.getResponse(for: requestDTO) { (result) in
            if case let .success(responseDTO?) = result {
                cached(responseDTO)
                return
            }
            
            task = self.networkService.request(with: endpoint) { result in
                switch result {
                case .success(let data):
                    let result: Result<WeatherForecastData, DataRepositoryError> = self.decode(response: data, of: requestDTO)
                    DispatchQueue.main.async { return completion(result) }
                case .failure(let error):
                    let dataError: DataRepositoryError = .networkFailure(error)
                    completion(.failure(dataError))
                }
            }
        }
        
        return task
    }
    
    // MARK: - Private
    private func decode(response data: Data?, of requestDTO: DailyRequestDTO) -> Result<WeatherForecastData, DataRepositoryError> {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result = try JSONDecoder().decode(DailyResponseDTO.self, from: data)
            self.cache.save(response: result, for: requestDTO)
            
            guard let response = result.data else {
                return .failure(.noResponse)
            }
            return .success(response)
        } catch {

            return .failure(.parsing(error))
        }
    }
}
