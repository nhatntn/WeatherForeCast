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
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var viewModel: ListItemViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let customFont = UIFont.preferredFont(forTextStyle: .body)
        [dateLabel, averageTempLabel, pressureLabel, humidityLabel, descriptionLabel].forEach { label in
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.7
            label?.adjustsFontForContentSizeCategory = true
            label?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: customFont)
        }
    }
    
    private func bind(to viewModel: ListItemViewModel) {
        viewModel.icon.observe(on: self) { [weak self] image in self?.updateIcon(with: image) }
    }
    
    func fill(with viewModel: ListItemViewModel) {
        self.viewModel = viewModel
        bind(to: viewModel)
        
        dateLabel.text = "Date: \(viewModel.dateLabel ?? "")"
        averageTempLabel.text = "Avarage Temperature: \(viewModel.averageTempLabel ?? "")°C"
        pressureLabel.text = "Pressure: \(viewModel.pressureLabel ?? "")"
        humidityLabel.text = "Humidity: \(viewModel.humidityLabel ?? "")%"
        descriptionLabel.text = "Description: \(viewModel.descriptionLabel ?? "")"
        
        viewModel.loadIcon()
    }
    
    private func updateIcon(with image: UIImage?) {
        guard let image = image else { return }
        iconImageView.image = image
    }
}
