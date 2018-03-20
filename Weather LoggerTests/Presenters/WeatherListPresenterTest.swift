//
//  WeatherDetailsPresenter.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 18/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger

class WeatherListPresenterTest: XCTestCase {
    
    //MARK: - Properties
    
    var presenter: WeatherListPresenterImplementation!
    let view: WeatherListViewSpy = WeatherListViewSpy()
    let request: WeatherDataRequestStub = WeatherDataRequestStub()
    var locationService: LocationServiceStub!
    let coreDataWeatherDataSerivce = CoreDataWeatherDataServiceStub()
    
    let detailsView = WeatherDetailsViewSpy()
    var detailsPresenter: WeatherDetailsPresenterImplementation!
    let detailsCoreDataWeatherDataSerivce = CoreDataWeatherDataServiceStub()
    
    //MARK: - Set up
    
    override func setUp() {
        super.setUp()
        
        presenter = WeatherListPresenterImplementation(view: view)
        locationService = LocationServiceStub(delegate: presenter)
        presenter.locationSerive = locationService
        presenter.weatherRequest = request
        presenter.coreDataSerivce = coreDataWeatherDataSerivce
        
        detailsPresenter = WeatherDetailsPresenterImplementation(view: detailsView, model: nil)
        detailsPresenter.coreDataSerivce = detailsCoreDataWeatherDataSerivce
        detailsView.presenter = detailsPresenter
        
        presenter.delegate = detailsPresenter
    }
    
    //MARK: - Tests

    func test_dataSourceCount() {
        //Given
        let expectedDataSource = 3
        let modelsRequest = WeatherModel.createModelsArray(count: 1)
        let modelsCoreData = WeatherModel.createModelsArray(count: 2)
        request.resultToBeReturned = Result.success(modelsRequest.first!)
        coreDataWeatherDataSerivce.fetchResultToBeReturned = Result.success(modelsCoreData)
        locationService.locationIsEnabledToBeReturned = true
        locationService.resultToBeReturned = (25, 25)
        
        // When
        presenter.prepareDataSource()
        
        //Then
        XCTAssertEqual(expectedDataSource, presenter.dataSourceCount)
        
    }
    
    func test_prepareLocation_Failure() {
        //Given
        let errorToBeDisplayed = "Please, give access for location"
        coreDataWeatherDataSerivce.fetchResultToBeReturned = .failure(NSError.parseError)
        locationService.locationIsEnabledToBeReturned = false
        
        // When
        presenter.prepareDataSource()
        
        //Then
        XCTAssertEqual(view.showedMessage, errorToBeDisplayed)
    }
    
    func test_getWeatherRequest_failure() {
        //Given
        let errorToBeDisplayed = NSError.parseError.localizedDescription
        let retryToBeDisplayed = "Retry"
        coreDataWeatherDataSerivce.fetchResultToBeReturned = .failure(NSError.parseError)
        locationService.locationIsEnabledToBeReturned = true
        locationService.resultToBeReturned = (25, 25)
        request.resultToBeReturned = .failure(NSError.parseError)
        view.callRetryHandler = true
        
        //When
        presenter.prepareDataSource()
        
        //Then
        XCTAssertEqual(view.showedMessage, errorToBeDisplayed)
        XCTAssertEqual(view.retryText, retryToBeDisplayed)
    }
    
    func test_configure_WeatherListCellView() {
        //Given
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.fetchResultToBeReturned = Result.success([model])
        let expectedTemp = "\(model.main.temp) °C"
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
        let expectedDate = dateFormater.string(from: Date())
        
        locationService.locationIsEnabledToBeReturned = false
        let viewCell = WeatherListCellViewSpy()
        let cellPresenter = WeatherListCellPresenterImplementation(view: viewCell)
        viewCell.presenter = cellPresenter
        
        //When
        presenter.prepareDataSource()
        presenter.configure(view: viewCell, atIndex: 0)
        
        //Then
        XCTAssertEqual(expectedTemp, viewCell.temperatureDisplayed)
        XCTAssertEqual(expectedDate, viewCell.dateDisplayed)
    }
    
    func test_WeatherListCell_Delete_Success() {
        //Given
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.fetchResultToBeReturned = Result.success([model])
        
        locationService.locationIsEnabledToBeReturned = false
        let viewCell = WeatherListCellViewSpy()
        let cellPresenter = WeatherListCellPresenterImplementation(view: viewCell)
        viewCell.presenter = cellPresenter
        coreDataWeatherDataSerivce.deleteResultToBeReturned = true
        
        //When
        presenter.prepareDataSource()
        presenter.configure(view: viewCell, atIndex: 0)
        cellPresenter.deletButtonTapped()
        
        //Then
        XCTAssertEqual(presenter.dataSourceCount, 0)
        XCTAssert(view.isViewReloadedAnimated)
    }
    
    func test_WeatherListCell_Delete_Failure() {
        //Given
        let expectedErrorMessage = "An error occurred, while delete object"
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.fetchResultToBeReturned = Result.success([model])
        
        locationService.locationIsEnabledToBeReturned = false
        let viewCell = WeatherListCellViewSpy()
        let cellPresenter = WeatherListCellPresenterImplementation(view: viewCell)
        viewCell.presenter = cellPresenter
        coreDataWeatherDataSerivce.deleteResultToBeReturned = false
        
        //When
        presenter.prepareDataSource()
        presenter.configure(view: viewCell, atIndex: 0)
        cellPresenter.deletButtonTapped()
        
        //Then
        XCTAssertEqual(view.showedMessage, expectedErrorMessage)
    }
    
    func test_WeatherListCell_Delete_Success_WithDisplayedDetails() {
        //Given
        let model = WeatherModel.createModelsArray(count: 1).first!
        coreDataWeatherDataSerivce.fetchResultToBeReturned = Result.success([model])
        
        locationService.locationIsEnabledToBeReturned = false
        let viewCell = WeatherListCellViewSpy()
        let cellPresenter = WeatherListCellPresenterImplementation(view: viewCell)
        viewCell.presenter = cellPresenter
        coreDataWeatherDataSerivce.deleteResultToBeReturned = true
        
        //When
        presenter.prepareDataSource()
        presenter.configure(view: viewCell, atIndex: 0)
        presenter.detailsButtonTappedAt(index: 0)
        cellPresenter.deletButtonTapped()
        
        //Then
        XCTAssertEqual(presenter.dataSourceCount, 0)
        XCTAssert(view.isViewReloadedAnimated)
        XCTAssertEqual(detailsView.titleDsiplayed, nil)
        XCTAssert(!detailsView.isSaveEnabled)
    }
    
    func test_configure_WeatherDetailsView_WithSaveClosure() {
        //Given
        let model = WeatherModel.createModelsArray(count: 1).first!
        let localModel = WeatherModel.createLocalModelsArray(count: 1).first!
        detailsCoreDataWeatherDataSerivce.addingResultToBeReturned = Result.success(localModel)
        
        //When
        presenter.configure(view: detailsView, withModel: model)
        detailsPresenter.saveData()
        
        //Then
        XCTAssertEqual(detailsView.titleDsiplayed, model.name)
        XCTAssertEqual(detailsPresenter.model!.id, model.id)
        XCTAssert(view.isViewReloaded)
    }
    
    func test_cellHeight() {
        //Given
        let expectedHeight: Float = 75.0
        
        //When
        let result = presenter.cellHeight
        
        //Then
         XCTAssertEqual(expectedHeight, result)
    }
    
    func test_cellIdentifier() {
        //Given
        let expectedIdentifier = "WeatherListTableViewCell"
        
        //When
        let result = presenter.weatherCellIndetifier
        
        //Then
        XCTAssertEqual(expectedIdentifier, result)
    }
}
