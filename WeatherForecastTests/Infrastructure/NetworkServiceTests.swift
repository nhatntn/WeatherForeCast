//
//  NetworkServiceTests.swift
//  WeatherForecastTests
//
//  Created by Sarah Nguyen on 26/05/2022.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    struct MockModel: Decodable {
        let name: String
    }

    func test_receivedValidJsonInResponse() {
        //given
        let expectation = self.expectation(description: "Should decode mock object")
        let config = NetworkConfigurableMock()
        let responseData = #"{"name": "Nguyen Tai Nhat"}"#.data(using: .utf8)
        let urlSession = URLSessionManagerMock(response: nil, data: responseData, error: nil)
        let networkService = NetworkService(config: config, urlSession: urlSession)
        
        //when
        _ = networkService.request(with: Endpoint<MockModel>(path: "http://test.com", method: .get)) { response in
            do {
                let object = try JSONDecoder().decode(MockModel.self, from: response.get() ?? Data())
                
                XCTAssertEqual(object.name, "Nguyen Tai Nhat")
                expectation.fulfill()
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        
        //then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_invalidResponse() {
        //given
        let expectation = self.expectation(description: "Should not decode mock object")
        let config = NetworkConfigurableMock()
        let urlSession = URLSessionManagerMock(response: nil, data: nil, error: nil)
        let networkService = NetworkService(config: config, urlSession: urlSession)

        //when
        _ = networkService.request(with: Endpoint<MockModel>(path: "http://test.com", method: .get)) { response in
            do {
                _ = try JSONDecoder().decode(MockModel.self, from: response.get() ?? Data())
                XCTFail("Should not happen")
            } catch {
                expectation.fulfill()
            }
        }

        //then
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_networkError() {
        //given
        let expectation = self.expectation(description: "Should catch exception")
        let config = NetworkConfigurableMock()
        
        let response = HTTPURLResponse(url: URL(string: "http://test.com")!,
                                       statusCode: 404,
                                       httpVersion: nil,
                                       headerFields: nil)
        
        let urlSession = URLSessionManagerMock(response: response, data: nil, error: NetworkError.notConnected)
        let networkService = NetworkService(config: config, urlSession: urlSession)

        //when
        _ = networkService.request(with: Endpoint<MockModel>(path: "http://test.com", method: .get)) { response in
            do {
                _ = try response.get()
                XCTFail("Should not happen")
            } catch let error {
                print(error)
                expectation.fulfill()
            }
        }

        //then
        waitForExpectations(timeout: 1, handler: nil)
    }
}
