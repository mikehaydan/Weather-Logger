//
//  WeatherModelTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger

class WeatherModelTest: XCTestCase {
    
    //MARK: - Tests

    func test_fetchWeatherModel_failure_nilData() {
        //Given
        let apiClient = ApiClientImplelentationSpy()
        let reuqest = WeatherDataRequestImplementation(apiClient: apiClient)
        
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedError = ApiParseError(error: NSError.parseError, httpUrlResponse: expectedHttpResponse, data: nil)
        apiClient.set(response: (nil, expectedHttpResponse, nil))
        let expectedResult: Result<WeatherModel> = Result.failure(expectedError)
        let fetchExpectation = expectation(description: "Get weather expectation")
        
        //When
        reuqest.fetchWeatherFor(latitude: 20, andLongitude: 20) { (result) in
            //Then
            XCTAssertEqual(result, expectedResult)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 1)
    }
    
    func test_init_Dictionary_falilure() {
        let expectedJson = ["test": "test2"]
        let expectedError = NSError.parseError
        
        do {
            let _ = try WeatherModel(json: expectedJson)
            XCTFail("Init should fail")
        } catch {
            XCTAssertEqual(expectedError.localizedDescription, error.localizedDescription)
        }
    }
}
