//
//  CoreDataWeatherDataSerivceTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger


class CoreDataWeatherDataSerivceTest: XCTestCase {
    
    //MARK: - Properties

    var coreDataSerivce: CoreDataWeatherDataSerivceImplementation!
    let managedObjectSpy = NSManagedObjectContextSpy()
    
    //MARK: - Set Up
    
    override func setUp() {
        super.setUp()
        
        coreDataSerivce = CoreDataWeatherDataSerivceImplementation(viewContext: managedObjectSpy)
    }
    
    
    //MARK: - Tests
    
    func test_add_success() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 1).first!
        let addExpectation = expectation(description: "Add weather expectation")
        
        let expectedResult = Result.success(expectedLocalModel)
        managedObjectSpy.addEntityToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.add(model: expectedModel) { (result) in
            //Then
            XCTAssertEqual(result, expectedResult)
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 1)
    }
    
    func test_add_failure_save() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        let addExpectation = expectation(description: "Add weather expectation")
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 1).first!
        
        let expectedError = NSError(domain: "com.Mike.App", code: -123, userInfo: [NSLocalizedDescriptionKey: "A save error occupted"])
        
        let expectedResult: Result<WeatherLocalModel> = Result.failure(expectedError)
        managedObjectSpy.saveErrorToReturn = expectedError
        managedObjectSpy.addEntityToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.add(model: expectedModel) { (result) in
            //Then
            XCTAssertEqual(result, expectedResult)
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 1)
    }
    
    func test_add_failure_WeatherLocal_nil() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        let addExpectation = expectation(description: "Add weather expectation")
        let expectedError = CoreDataError(message: "Failed adding the weather in the data base")
        
        let expectedResult: Result<WeatherLocalModel> = Result.failure(expectedError)
        managedObjectSpy.saveErrorToReturn = expectedError
        managedObjectSpy.addEntityToReturn = nil
        
        //When
        coreDataSerivce.add(model: expectedModel) { (result) in
            //Then
            XCTAssertEqual(result, expectedResult)
            addExpectation.fulfill()
        }
        
        wait(for: [addExpectation], timeout: 1)
    }
    
    func test_delete_success() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 1).first!
        managedObjectSpy.enititiesToReturn = [expectedLocalModel]
        managedObjectSpy.deletedObject = expectedLocalModel
        
        let expectedResult = true
        
        //When
        let result = coreDataSerivce.delete(model: expectedModel)
        
        //Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_delete_failure_save() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 1).first!
        managedObjectSpy.enititiesToReturn = [expectedLocalModel]
        managedObjectSpy.deletedObject = expectedLocalModel
        let expectedError = CoreDataError(message: "Failed to save")
        managedObjectSpy.saveErrorToReturn = expectedError
        
        let expectedResult = false
        
        //When
        let result = coreDataSerivce.delete(model: expectedModel)
        
        //Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_delete_failure_get_enitites_to_delete() {
        //Given
        let expectedModel = WeatherModel.createModelsArray(count: 1).first!
        managedObjectSpy.enititiesToReturn = nil
        
        let expectedResult = false
        
        //When
        let result = coreDataSerivce.delete(model: expectedModel)
        
        //Then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetch_success() {
        //Given
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 3)
        let expectedModel = WeatherModel.createModelsArray(count: 3)
        let fetchExpectation = expectation(description: "fetch weather expectation")
        
        let expectedResult = Result.success(expectedModel)
        managedObjectSpy.enititiesToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.fetchWeather { (result) in
            XCTAssertEqual(result, expectedResult)
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 1)
    }
    
    func test_fetch_failure_coord_nil() {
        //Given
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 3)
        expectedLocalModel.first?.coord = nil
        let fetchExpectation = expectation(description: "fetch weather expectation")
        
        let expectedError = CoreDataError(message: "Not posiable to configure coord data")
        managedObjectSpy.enititiesToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.fetchWeather { (result) in
            guard case let .failure(error) = result else {
                XCTFail("Response shpuld be failure")
                return
            }
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 1)
    }
    
    func test_fetch_failure_sys_nil() {
        //Given
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 3)
        expectedLocalModel.first?.sys = nil
        let fetchExpectation = expectation(description: "fetch weather expectation")
        
        let expectedError = CoreDataError(message: "Not posiable to configure sys data")
        managedObjectSpy.enititiesToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.fetchWeather { (result) in
            guard case let .failure(error) = result else {
                XCTFail("Response shpuld be failure")
                return
            }
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 1)
    }
    
    func test_fetch_failure_main_nil() {
        //Given
        let expectedLocalModel = WeatherModel.createLocalModelsArray(count: 3)
        expectedLocalModel.first?.main = nil
        let fetchExpectation = expectation(description: "fetch weather expectation")
        
        let expectedError = CoreDataError(message: "Not posiable to configure main data")
        managedObjectSpy.enititiesToReturn = expectedLocalModel
        
        //When
        coreDataSerivce.fetchWeather { (result) in
            guard case let .failure(error) = result else {
                XCTFail("Response shpuld be failure")
                return
            }
            XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
            fetchExpectation.fulfill()
        }
        
        wait(for: [fetchExpectation], timeout: 1)
    }
    
}
