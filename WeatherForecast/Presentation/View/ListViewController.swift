//
//  ListViewController.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 21/05/2022.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var searchBarContainer: UIView!
    
    private var viewModel: ListViewModel!
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func instantiateViewController(_ bundle: Bundle? = nil) -> ListViewController {
        let fileName = NSStringFromClass(Self.self).components(separatedBy: ".").last ?? ""
        let storyboard = UIStoryboard(name: fileName, bundle: nil)
        
        guard let vc = storyboard.instantiateInitialViewController() as? ListViewController else {
            fatalError("Cannot instantiate initial view controller")
        }
        
        return vc
    }
    
    // MARK: - Lifecycle
    static func create(with viewModel: ListViewModel) -> ListViewController {
        let view = ListViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind(to: viewModel)
    }
    
    private func bind(to viewModel: ListViewModel) {
        viewModel.error.observe(on: self) { [weak self] in self?.showError($0) }
    }
    
    // MARK: - Private
    func setupViews() {
        title = viewModel.screenTitle
        setupSearchController()
    }
    
    private func showError(_ error: String) {
        guard !error.isEmpty else { return }
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Search Controller

extension ListViewController {
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = viewModel.searchBarPlaceholder
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.frame = searchBarContainer.bounds
        searchController.searchBar.autoresizingMask = [.flexibleWidth]
        searchBarContainer.addSubview(searchController.searchBar)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(query: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}

extension ListViewController: UISearchControllerDelegate {
    public func willPresentSearchController(_ searchController: UISearchController) {
        
    }

    public func willDismissSearchController(_ searchController: UISearchController) {
    
    }

    public func didDismissSearchController(_ searchController: UISearchController) {
    
    }
}
