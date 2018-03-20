//
//  ApiClientTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 19/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger

private struct RequestStub: ApiRequest {
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "https://www.google.com")!)
    }
}

class ApiClientTest: XCTestCase {
    
    //MARK: - Properties
    
    var apiClient: ApiClientImplelentation!
    
    let urlSessionStub = UrlSessionStub()
    
    //MARK: - Set up
    
    override func setUp() {
        super.setUp()
        
        apiClient = ApiClientImplelentation(urlSession: urlSessionStub)
    }
    
    //MARK: - Tests
    
    func test_execute_succes() {
        //Given
        let expectedResponse = """
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
        """
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        
        urlSessionStub.response.append((expectedData, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<WeatherModel>>) in
            //Then
            guard case let .success(response) = result else {
                XCTFail("A successfull response should be returned")
                return
            }
            XCTAssertEqual(response.data?.base64EncodedString(), expectedData.base64EncodedString())
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_succes_array() {
        //Given
        let expectedResponse = """
        [{"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200},
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}]
        """
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedArrayCount = 2
        urlSessionStub.response.append((expectedData, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<[WeatherModel]>>) in
            //Then
            guard case let .success(response) = result else {
                XCTFail("A successfull response should be returned")
                return
            }
            XCTAssertEqual(response.data?.base64EncodedString(), expectedData.base64EncodedString())
            XCTAssertEqual(response.model.count, expectedArrayCount)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_failure_statusCode() {
        //Given
        let expectedHttpResponse = HTTPURLResponse(statusCode: 400)
        let expextedError = StatusCodeError(data: nil, httpUrlResponse: expectedHttpResponse)
        
        urlSessionStub.response.append((nil, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<WeatherModel>>) in
            //Then
            guard case let .failure(error as StatusCodeError) = result else {
                XCTFail("A failure response should be returned")
                return
            }
            XCTAssertEqual(error.httpUrlResponse.statusCode, expextedError.httpUrlResponse.statusCode)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_failure_httpResponse_nil() {
        //Given
        let expextedError = NetworkRequestError(error: nil)
        
        urlSessionStub.response.append((nil, nil, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<WeatherModel>>) in
            //Then
            guard case let .failure(error as NetworkRequestError) = result else {
                XCTFail("A failure response should be returned")
                return
            }
            XCTAssertEqual(error.localizedDescription, expextedError.localizedDescription)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_failure_invalid_json() {
        //Given
        let expectedResponse = """
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_mias1"";:::285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
        """
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedLocalizedDescription = NSError.parseError.localizedDescription
        
        urlSessionStub.response.append((expectedData, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<WeatherModel>>) in
            //Then
            guard case let .failure(error as ApiParseError) = result else {
                XCTFail("A failure response should be returned")
                return
            }
            XCTAssertEqual(error.httpUrlResponse, expectedHttpResponse)
            XCTAssertEqual(error.data?.base64EncodedString(), expectedData.base64EncodedString())
            XCTAssertEqual(error.error.localizedDescription, expectedLocalizedDescription)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_failure_invalid_array_json() {
        //Given
        let expectedResponse = """
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_mias1"";:::285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}
        """
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedLocalizedDescription = NSError.parseError.localizedDescription
        
        urlSessionStub.response.append((expectedData, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<[WeatherModel]>>) in
            //Then
            guard case let .failure(error as ApiParseError) = result else {
                XCTFail("A failure response should be returned")
                return
            }
            XCTAssertEqual(error.httpUrlResponse, expectedHttpResponse)
            XCTAssertEqual(error.data?.base64EncodedString(), expectedData.base64EncodedString())
            XCTAssertEqual(error.error.localizedDescription, expectedLocalizedDescription)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
    
    func test_execute_failure_invalid_array_not_InitializableWithJson() {
        //Given
        let expectedResponse = """
        [{"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200},
        {"coord":{"lon":139.01,"lat":35.02},"weather":[{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}],"base":"stations","main":{"temp":285.514,"pressure":1013.75,"humidity":100,"temp_min":285.514,"temp_max":285.514,"sea_level":1023.22,"grnd_level":1013.75},"wind":{"speed":5.52,"deg":311},"clouds":{"all":0},"dt":1485792967,"sys":{"message":0.0025,"country":"JP","sunrise":1485726240,"sunset":1485763863},"id":1907296,"name":"Tawarano","cod":200}]
        """
        let expectedData = expectedResponse.data(using: .utf8)!
        let expectedHttpResponse = HTTPURLResponse(statusCode: 200)
        let expectedLocalizedDescription = NSError.parseError.localizedDescription
        urlSessionStub.response.append((expectedData, expectedHttpResponse, nil))
        let executeExpectation = expectation(description: "Execute expectation")
        
        //When
        
        apiClient.execute(request: RequestStub()) { (result: Result<ApiResponse<[Cords]>>) in
            //Then
            guard case let .failure(error as ApiParseError) = result else {
                XCTFail("A failure response should be returned")
                return
            }
            XCTAssertEqual(error.httpUrlResponse, expectedHttpResponse)
            XCTAssertEqual(error.data?.base64EncodedString(), expectedData.base64EncodedString())
            XCTAssertEqual(error.error.localizedDescription, expectedLocalizedDescription)
            executeExpectation.fulfill()
        }
        wait(for: [executeExpectation], timeout: 1)
    }
}
