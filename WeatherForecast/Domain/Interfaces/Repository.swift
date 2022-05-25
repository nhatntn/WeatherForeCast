//
//  Repository.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol Repository {
    @discardableResult
    func fetchList(query: String, cached: @escaping (String) -> Void,
                   completion: @escaping (Result<String, Error>) -> Void) -> NetworkCancellable?
}
