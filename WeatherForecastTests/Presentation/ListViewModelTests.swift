//
//  ListViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import XCTest

class ListViewModelTests: XCTestCase {
    func test_whenSearchUseCaseReturnsError_thenViewModelReturnError() {
        // given
        let searchUseCaseMock = SearchUseCaseMock()
        searchUseCaseMock.error = NetworkError.error(statusCode: 200, data: nil)
        let viewModel = DefaultListViewModel(searchUseCase: searchUseCaseMock)
        
        // when
        viewModel.didSearch(query: "test")
        
        // then
        XCTAssertFalse(viewModel.error.value.isEmpty)
    }
    
    func test_whenSearchUseCaseGetData_thenViewModelReturnData() {
        // given
        let data = MockJSONData().data(using: .utf8)!
        let decoder = JSONDecoder()
        
        let searchUseCaseMock = SearchUseCaseMock()
        let expectedResponse = try! decoder.decode(WeatherForecastData.self, from: data)
        searchUseCaseMock.data = expectedResponse
        let viewModel = DefaultListViewModel(searchUseCase: searchUseCaseMock)
        
        // when
        viewModel.didSearch(query: "test")
        
        // then
        XCTAssertTrue(viewModel.items.value.count > 0)
    }
    
    func test_whenSearchWithEmptyString_thenViewModelRejectAcion() {
        // given
        let searchUseCaseMock = SearchUseCaseMock()
        searchUseCaseMock.error = NetworkError.error(statusCode: 200, data: nil) //Fake error
        let viewModel = DefaultListViewModel(searchUseCase: searchUseCaseMock)
        
        // when
        viewModel.didSearch(query: "")
        
        // then
        XCTAssertTrue(viewModel.error.value.isEmpty)
    }
}
