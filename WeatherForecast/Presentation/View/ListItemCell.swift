//
//  ListItemCell.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import Foundation
import UIKit

final class ListItemCell: UITableViewCell {
    static let reuseIdentifier = String(describing: ListItemCell.self)
    static let height = CGFloat(150)
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var averageTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func fill(with viewModel: ListItemViewModel) {
        dateLabel.text = "Date: \(viewModel.dateLabel ?? "")"
        averageTempLabel.text = "Avarage Temperature: \(viewModel.averageTempLabel ?? "")"
        pressureLabel.text = "Pressure: \(viewModel.pressureLabel ?? "")"
        humidityLabel.text = "Humidity: \(viewModel.humidityLabel ?? "")"
        descriptionLabel.text = "Description: \(viewModel.descriptionLabel ?? "")"
    }
}
