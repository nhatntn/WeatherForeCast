//
//  SearchUseCaseTests.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import XCTest

class SearchUseCaseTests: XCTestCase {

    func test_SearchUseCase_FetchSuccessfully() {
        // given
        let expectation = self.expectation(description: "search use case and get data successfully")

        let data = MockJSONData().data(using: .utf8)!
        let decoder = JSONDecoder()
        let expectedResponse = try! decoder.decode(WeatherForecastData.self, from: data)
        let useCase = DefaultSearchUseCase(repository: RepositoryMock(result: .success(expectedResponse)))
        
        
        // when
        let requestValue = "Saigon"
        var responseData: WeatherForecastData?
        _ = useCase.execute(requestValue: requestValue, cached: {_ in}, completion: { (response) in
            switch response {
            case .success(let data):
                responseData = data
                expectation.fulfill()
            case .failure:
                XCTFail("Should not happen")
            }
        })
        
        //then
        XCTAssertTrue(responseData?.listItems.count ?? 0 == 7)
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func test_SearchUseCase_CachedSuccessfully() {
        // given
        let expectation = self.expectation(description: "search use case and cached data successfully")
        expectation.expectedFulfillmentCount = 2
        
        let data = MockJSONData().data(using: .utf8)!
        let decoder = JSONDecoder()
        let expectedResponse = try! decoder.decode(WeatherForecastData.self, from: data)
        let useCase = DefaultSearchUseCase(repository: RepositoryMock(result: .success(expectedResponse)))
        
        // when
        let requestValue = "Saigon"
        _ = useCase.execute(requestValue: requestValue, cached: {_ in}, completion: { (response) in
            switch response {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Should not happen")
            }
        })
        
        //then
        _ = useCase.execute(requestValue: requestValue, cached: { (items) in
            XCTAssertTrue(items.count == 7)
            expectation.fulfill()
        }, completion: { (_) in })
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}

