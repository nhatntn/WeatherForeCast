//
//  AppConfigurations.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 21/05/2022.
//

import Foundation

final class AppConfiguration {
    lazy var appID: String = {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "AppID") as? String else {
            fatalError("AppID must not be empty in plist")
        }
        return appID
    }()
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        return apiBaseURL
    }()
    lazy var iconBaseURL: String = {
        guard let iconBaseURL = Bundle.main.object(forInfoDictionaryKey: "IconBaseURL") as? String else {
            fatalError("IconBaseURL must not be empty in plist")
        }
        return iconBaseURL
    }()
}
