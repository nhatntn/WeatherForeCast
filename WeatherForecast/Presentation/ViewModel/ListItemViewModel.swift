//
//  ListItemViewModel.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation
import UIKit

protocol ListItemViewModelInput {
    func loadIcon()
}

protocol ListItemViewModelOutput {
    var icon: Observable<UIImage?> { get }
}

final class ListItemViewModel: ListItemViewModelInput, ListItemViewModelOutput {
    let dateLabel: String?
    let averageTempLabel: String?
    let pressureLabel: String?
    let humidityLabel: String?
    let descriptionLabel: String?
    
    let iconPath: String?
    let icon: Observable<UIImage?> = Observable(nil)
    var iconRepository: IconRepository?
    
    init(from item: WeatherForecastItem, iconRepository: IconRepository? = nil) {
        let timeStr = DateFormatterHelper.stringForDateInterval(
            timeIntervalSince1970: item.dateInterval,
            format: "EEE, dd MMM yyyy",
            timeIntervalType: .seconds
        )
        let averageTemp = Int(((item.temperature.max + item.temperature.min) / 2.0).rounded(.toNearestOrEven))
        let description = item.weatherItems.compactMap { $0.description }.joined(separator: ", ")
        
        self.dateLabel = timeStr
        self.averageTempLabel = "\(averageTemp)"
        self.pressureLabel = "\(item.pressure)"
        self.humidityLabel = "\(item.humidity)"
        self.descriptionLabel = description
        self.iconPath = item.weatherItems.first?.icon ?? ""
        self.iconRepository = iconRepository
    }
    
    func loadIcon() {
        guard let iconPath = iconPath else {
            return
        }
        
        _ = iconRepository?.fetchImage(with: iconPath + "@2x.png") { [weak self] result in
            guard let self = self else { return }
            
            if case let .success(data) = result {
                self.icon.value = UIImage(data: data ?? Data())
            }
        }
    }
}
