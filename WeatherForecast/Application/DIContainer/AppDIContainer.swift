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
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
                                          queryParameters: ["appid": appConfiguration.appID])
        return NetworkService(config: config)
    }()
    
    lazy var iconNetworkService: Networkable = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.iconBaseURL)!)
        return NetworkService(config: config)
    }()
    
    // MARK: - DIContainers of scenes
    func makeWeatherForecaseDIContainer() -> WeatherForecaseDIContainer {
        let dependencies = WeatherForecaseDIContainer.Dependencies(networkService: networkService,
                                                                   iconNetworkService: iconNetworkService)
        return WeatherForecaseDIContainer(dependencies: dependencies)
    }
}
