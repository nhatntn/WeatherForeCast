//
//  ListViewModelActions.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

struct ListViewModelActions {
    let showQueriesSuggestions: (@escaping (_ didSelect: String) -> Void) -> Void
    let closeQueriesSuggestions: () -> Void
}
