//
//  DailyRequestDTO+Mapping.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

struct DailyRequestDTO : Encodable {
    let q: String
    let cnt: Int
    let units: String
}
