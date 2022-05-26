//
//  DateFormatterHelper.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation

public enum TimeIntervalType {
    case seconds
    case milisecond
}

public enum DateFormatterHelper {
    public static func stringForDateInterval(
        timeIntervalSince1970: TimeInterval,
        format: String,
        timeIntervalType: TimeIntervalType = .milisecond
    ) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        
        let time: TimeInterval
        switch timeIntervalType {
        case .milisecond:
            time = timeIntervalSince1970 / 1_000
        case .seconds:
            time = timeIntervalSince1970
        }
        
        return dateFormater.string(from: Date(timeIntervalSince1970: time))
    }
}
