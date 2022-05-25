//
//  AppFlowCoordinator.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 24/05/2022.
//

import Foundation
import UIKit

final class AppFlowCoordinator {
    var naviController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(naviController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.naviController = naviController
        self.appDIContainer = appDIContainer
    }
    
    func start() {
        let weatherForecastDIContainer = appDIContainer.makeWeatherForecaseDIContainer()
        let flow = weatherForecastDIContainer.makeSearchFlowCoordinator(navigationController: naviController)
        flow.start()
    }
}
