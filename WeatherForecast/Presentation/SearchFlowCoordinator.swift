//
//  SearchFlowCoordinator.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import UIKit

protocol SearchFlowCoordinatorDependencies  {
    func makeListViewController(actions: ListViewModelActions) -> ListViewController
}

final class SearchFlowCoordinator {
    
    private weak var naviController: UINavigationController?
    private let dependencies: SearchFlowCoordinatorDependencies
    
    private weak var listVC: ListViewController?
    
    init(navigationController: UINavigationController,
         dependencies: SearchFlowCoordinatorDependencies) {
        self.naviController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = ListViewModelActions(showQueriesSuggestions: showQueriesSuggestions,
                                           closeQueriesSuggestions: closeQueriesSuggestions)
        let vc = dependencies.makeListViewController(actions: actions)
        
        naviController?.pushViewController(vc, animated: false)
        listVC = vc
    }
    
    private func showQueriesSuggestions(didSelect: @escaping (String) -> Void) {
        
    }
    
    private func closeQueriesSuggestions() {
        
    }
}
