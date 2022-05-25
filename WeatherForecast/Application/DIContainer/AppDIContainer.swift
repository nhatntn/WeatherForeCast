//
//  AppDIContainer.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var networkService: Networkable = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        
        return NetworkService(config: config)
    }()
    
    // MARK: - DIContainers of scenes
    func makeWeatherForecaseDIContainer() -> WeatherForecaseDIContainer {
        let dependencies = WeatherForecaseDIContainer.Dependencies(networkService: networkService)
        return WeatherForecaseDIContainer(dependencies: dependencies)
    }
}
