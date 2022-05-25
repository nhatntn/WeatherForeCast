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
    func didSelectItem(at index: Int)
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
    
    // MARK: -
    private func query(with string: String) {
        query.value = string
        loadTask = searchUseCase.execute(requestValue: string, cached: { (items) in
            
        }, completion: { (result) in
            switch result {
            case .success(let page):
                break
            case .failure(let error):
                break
            }
        })
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

    func didCancelSearch() {
        
    }

    func showQueriesSuggestions() {
        
    }

    func closeQueriesSuggestions() {
        
    }

    func didSelectItem(at index: Int) {
        
    }
}
