//
//  AppDelegate.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 21/05/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()

        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(naviController: navigationController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
    
        print("ApplicationSupportDirectory: ", FileManager.default.urls(for: .applicationSupportDirectory,
                                                                in: .userDomainMask).last ?? "Not Found!")

        return true
    }
    
    
}

