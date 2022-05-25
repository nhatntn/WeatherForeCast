//
//  ListViewModel.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import Foundation

protocol ListViewModelInput {
    func didSearch(query: String)
    func didCancelSearch()
    func showQueriesSuggestions()
    func closeQueriesSuggestions()
}

protocol ListViewModelOutput {
    var items: Observable<[ListItemViewModel]> { get }
    var query: Observable<String> { get }
    var error: Observable<String> { get }
    var isEmpty: Bool { get }
    var screenTitle: String { get }
    var searchBarPlaceholder: String { get }
}

protocol ListViewModel: ListViewModelInput, ListViewModelOutput {}

final class DefaultListViewModel: ListViewModel {
    private let searchUseCase: SearchUseCase
    private let actions: ListViewModelActions?
    
    private var loadTask: NetworkCancellable? { willSet { loadTask?.cancel() } }
    
    // MARK: - OUTPUT
    let items: Observable<[ListItemViewModel]> = Observable([])
    let query: Observable<String> = Observable("")
    let error: Observable<String> = Observable("")
    var isEmpty: Bool { return items.value.isEmpty }
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
        loadTask = searchUseCase.execute(requestValue: string, cached: { (items) in
            
        }, completion: { (result) in
            switch result {
            case .success(let items):
                break
            case .failure(let error):
                self.handle(error: error)
            }
        })
    }
    
    private func handle(error: NetworkError) {
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
        
    }

    func didCancelSearch() {
        
    }

    func showQueriesSuggestions() {
        
    }

    func closeQueriesSuggestions() {
        
    }
}
