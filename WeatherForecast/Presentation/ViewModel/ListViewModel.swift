//
//  ListViewModel.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol ListViewModelInput {
    func didSearch(query: String)
}

protocol ListViewModelOutput {
    var items: Observable<[ListItemViewModel]> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var screenTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput {}

final class DefaultListViewModel: ListViewModel {
    private let searchUseCase: SearchUseCase
    private let actions: ListViewModelActions?
    
    // MARK: - OUTPUT
    let items: Observable<[ListItemViewModel]> = Observable([])
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let screenTitle = NSLocalizedString("Weather Forecast", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
    
    // MARK: - Init
    init(searchUseCase: SearchUseCase,
         actions: ListViewModelActions? = nil) {
        self.searchUseCase = searchUseCase
        self.actions = actions
    }
    
    // MARK: - Private
    private func query(with string: String) {
        query.value = string
        _ = searchUseCase.execute(requestValue: string, cached: { (items) in
            self.load(with: items)
        }, completion: { (result) in
            switch result {
            case .success(let data):
                self.load(with: data.listItems)
            case .failure(let error):
                self.handle(error: error)
            }
        })
    }
    
    private func load(with items: [WeatherForecastItem]) {
        self.items.value = items.map {
            let timeStr = DateFormatterHelper.stringForDateInterval(
                timeIntervalSince1970: $0.dateInterval,
                format: "EEE, dd MMM yyyy",
                timeIntervalType: .seconds
            )
            
            let averageTemp = Int((($0.temperature.max + $0.temperature.min) / 2.0).rounded(.toNearestOrEven))
            let description = $0.weatherItems.compactMap({ $0.description }).joined(separator: ", ")
            
            return ListItemViewModel(dateLabel: timeStr,
                                     averageTempLabel: "\(averageTemp)",
                                     pressureLabel: "\($0.pressure)",
                                     humidityLabel: "\($0.humidity)",
                                     descriptionLabel: description)
        }
    }
    
    private func handle(error: NetworkError) {
        self.items.value.removeAll()
        switch error {
        case .notConnected:
            self.error.value = "No internet connection"
        case .invalidJSON, .invalidURL:
            self.error.value = "Something went wrong. Check your input again!"
        case .error(_, data: nil):
            self.error.value = "Can't find related locations"
        default:
            self.error.value = "Something went wrong. Please try again!"
        }
    }
}

// MARK: - INPUT. View event methods
extension DefaultListViewModel {
    func didSearch(query: String) {
        guard !query.isEmpty else {
            return
        }
        self.query(with: query)
    }
}
