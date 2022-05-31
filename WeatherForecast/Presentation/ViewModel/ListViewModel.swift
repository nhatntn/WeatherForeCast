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
    private let iconRepository: IconRepository?
    private var iconLoadTask: NetworkCancellable? { willSet { iconLoadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let items: Observable<[ListItemViewModel]> = Observable([])
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    let icon: Observable<Data?> = Observable(nil)
    let screenTitle = NSLocalizedString("Weather Forecast", comment: "")
    let searchBarPlaceholder = NSLocalizedString("Search", comment: "")
    
    // MARK: - Init
    init(searchUseCase: SearchUseCase, iconRepository: IconRepository? = nil) {
        self.searchUseCase = searchUseCase
        self.iconRepository = iconRepository
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
        self.items.value = items.map{
            ListItemViewModel.init(from: $0, iconRepository: iconRepository)
        }
    }
    
    private func handle(error: DataRepositoryError) {
        self.items.value.removeAll()
        switch error {
        case .networkFailure(let error):
            print("Log: Network Error \(error.localizedDescription)")
            self.error.value = "Check your internet connection"
        case .noResponse:
            self.error.value = "Can't find related locations"
        case .parsing(let error):
            print("Log: Parsing Error \(error.localizedDescription)")
            self.error.value = "Something went wrong. Check your input again!"
        case .invalidInput:
            self.error.value = "Search information must have at least 3 characters"
        }
    }
    
    // MARK: - INPUT. View event methods
    func didSearch(query: String) {
        self.query(with: query)
    }
}
