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
    private var iconRepository: IconRepository?
    private var imageLoadTask: NetworkCancellable? { willSet { imageLoadTask?.cancel() } }
    
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
    
    func fill(with viewModel: ListItemViewModel, iconRepository: IconRepository?) {
        self.viewModel = viewModel
        self.iconRepository = iconRepository
        
        dateLabel.text = "Date: \(viewModel.dateLabel ?? "")"
        averageTempLabel.text = "Avarage Temperature: \(viewModel.averageTempLabel ?? "")°C"
        pressureLabel.text = "Pressure: \(viewModel.pressureLabel ?? "")"
        humidityLabel.text = "Humidity: \(viewModel.humidityLabel ?? "")%"
        descriptionLabel.text = "Description: \(viewModel.descriptionLabel ?? "")"
        updateIcon()
    }
    
    private func updateIcon() {
        iconImageView.image = nil
        guard let iconPath = viewModel.icon else { return }

        imageLoadTask = iconRepository?.fetchImage(with: iconPath + "@2x.png") { [weak self] result in
            guard let self = self else { return }
            guard self.viewModel.icon == iconPath else { return }
            if case let .success(data) = result {
                self.iconImageView.image = UIImage(data: data ?? Data())
            }
            self.imageLoadTask = nil
        }
    }
}
