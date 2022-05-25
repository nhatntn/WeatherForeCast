//
//  AppDIContainer.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 21/05/2022.
//

import Foundation
import Moya

final class AppDIContainer {
    func makeWeatherForecaseDIContainer() -> WeatherForecastDIContainer<NetworkManager> {
        return WeatherForecastDIContainer<NetworkManager>()
    }
}
