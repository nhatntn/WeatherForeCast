//
//  WeatherForecaseDIContainer.swift
//  WeatherForecast
//
//  Created by Sarah Nguyen on 25/05/2022.
//

import UIKit

final class WeatherForecaseDIContainer {
    struct Dependencies {
        let networkService: Networkable
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var queriesStorage: QueriesStorage = CoreDataQueriesStorage(maxStorageLimit: 10)
    lazy var responseCache: ResponseStorage = CoreDataResponseStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeSearchUseCase() -> SearchUseCase {
        return DefaultSearchUseCase(repository: makeRepository(),
                                    queriesRepository: makeQueriesRepository())
    }
    
    // MARK: - Repositories
    func makeRepository() -> Repository {
        return DefaultRepository(networkService: dependencies.networkService,
                                 cache: responseCache)
    }
    
    func makeQueriesRepository() -> QueriesRepository {
        return DefaultQueriesRepository(networkService: dependencies.networkService,
                                        persistentStorage: queriesStorage)
    }
    
    // MARK: - Flow Coordinators
    func makeSearchFlowCoordinator(navigationController: UINavigationController) -> SearchFlowCoordinator {
        return SearchFlowCoordinator(navigationController: navigationController,
                                     dependencies: self)
    }
    
    func makeListViewModel(actions: ListViewModelActions) -> ListViewModel {
        return DefaultListViewModel(searchUseCase: makeSearchUseCase(),
                                    actions: actions)
    }
}


extension WeatherForecaseDIContainer: SearchFlowCoordinatorDependencies {
    func makeListViewController(actions: ListViewModelActions) -> ListViewController {
        return ListViewController.create(with: makeListViewModel(actions: actions))
    }
}
