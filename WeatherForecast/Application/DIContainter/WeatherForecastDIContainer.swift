//
//  WeatherForecastDIContainer.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 24/05/2022.
//

import Foundation

final class WeatherForecastDIContainer {
    struct Dependencies {
        let dataService: DefaultDataService
    }
    
    private let dependencies: Dependencies

    // MARK: - Persistent Storage

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
}


