//
//  WeatherDetailsPresenterTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger


class WeatherDetailsPresenterTest: XCTestCase {
    
    //MARK: - Properties

    let view = WeatherDetailsViewSpy()
    var presenter: WeatherDetailsPresenterImplementation!
    let coreDataWeatherDataSerivce = CoreDataWeatherDataServiceStub()
    
    //MARK: - Set up
    
    override func setUp() {
        super.setUp()
        
        presenter = WeatherDetailsPresenterImplementation(view: view, model: nil)
        presenter.coreDataSerivce = coreDataWeatherDataSerivce
        view.presenter = presenter
        
        view.cells[WeatherInfoTableViewCell.nibName] = WeatherInfoTableViewCellSpy()
        view.cells[WeatherMainInfoTableViewCell.nibName] = WeatherMainInfoTableViewCellSpy()
        view.cells[WeatherAdditionalDataTableViewCell.nibName] = WeatherAdditionalDataTableViewCellSpy()
    }
    
    //MARK: - Tests

    func test_saveData_Success() {
        //Given
        let expectedMessage = "Success"
        let localModel = WeatherModel.createLocalModelsArray(count: 1).first!
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.addingResultToBeReturned = Result.success(localModel)
        
        //When
        presenter.model = model
        presenter.saveData()
        
        //Then
        XCTAssertEqual(view.messageDisplayed, expectedMessage)
        XCTAssertEqual(model.id, Int(localModel.id))
    }
    
    func test_saveData_Failure() {
        //Given
        let expectedMessage = NSError.parseError.localizedDescription
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.addingResultToBeReturned = Result.failure(NSError.parseError)
        
        //When
        presenter.model = model
        presenter.saveData()
        
        //Then
        XCTAssertEqual(view.messageDisplayed, expectedMessage)
    }
    
    func test_cells_configure() {
        //Given
        let model = WeatherModel.createModelsArray(count: 1).first!
        let expectedHumidityText = "\(model.main.humidity)"
        let weatherInfoCell = WeatherInfoTableViewCellSpy()
        let mainInfoCell = WeatherMainInfoTableViewCellSpy()
        let additionalInfoCell = WeatherAdditionalDataTableViewCellSpy()
        view.cells[WeatherInfoTableViewCell.nibName] = weatherInfoCell
        view.cells[WeatherMainInfoTableViewCell.nibName] = mainInfoCell
        view.cells[WeatherAdditionalDataTableViewCell.nibName] = additionalInfoCell
        view.emulateTableView = true
        
        //When
        presenter.model = model
        
        //Then
        XCTAssert(view.isDeailsReloaded)
        XCTAssertEqual(weatherInfoCell.weatherDescription, model.weather.first!.descriptionText)
        XCTAssertEqual(mainInfoCell.humidityDataText, expectedHumidityText)
        XCTAssertEqual(additionalInfoCell.countryText, model.sys.countryName)
    }
}
