//
//  WeatherDataRequestTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 19/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger


class WeatherDataRequestTest: XCTestCase {
    
    //MARK: - Properties
    
    var reuqest: WeatherDataRequestImplementation!
    
    let apiClient = ApiClientImplelentationSpy()
    
    //MARK: - Set up
    
    override func setUp() {
        super.setUp()
        
        reuqest = WeatherDataRequestImplementation(apiClient: apiClient)

    }
    
    //MARK: - Tests
    
    func test_fetchWeather_success() {
        //Given
        let expectedResponse = """
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
        """
        let expectedData = expectedResponse.data(using: .utf8)
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedModel = try! WeatherModel(data: expectedData)
        let expectedResult = Result.success(expectedModel)
        let fetchExpectation = expectation(description: "Get weather expectation")
        apiClient.set(response: (expectedData, expectedHttpResponse, nil))
        
        //When
        reuqest.fetchWeatherFor(latitude: 20, andLongitude: 20) { (result) in
            //Then
            XCTAssertEqual(result, expectedResult)
            fetchExpectation.fulfill()
        }
        wait(for: [fetchExpectation], timeout: 1)
    }
    
    func test_fetchWeather_failure_networkError() {
        //Given
        let expectedError: NetworkRequestError = NetworkRequestError(error: nil)
        apiClient.set(response: (nil, nil, nil))
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
}
