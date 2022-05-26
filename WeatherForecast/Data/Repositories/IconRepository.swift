//
//  IconRepository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

final class DefaultIconRepository {
    
    private let networkService: Networkable

    init(networkService: Networkable) {
        self.networkService = networkService
    }
}

extension DefaultIconRepository: IconRepository {
    func fetchImage(with iconPath: String, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> NetworkCancellable? {
        var task: NetworkCancellable?
        let endpoint = APIEndpoints.getIcon(with: iconPath)

        task = self.networkService.request(with: endpoint) { (result: Result<Data?, NetworkError>) in
            let result = result.mapError { NetworkError.generic(error: $0) }
            DispatchQueue.main.async { completion(result) }
        }
        
        return task
    }
}
