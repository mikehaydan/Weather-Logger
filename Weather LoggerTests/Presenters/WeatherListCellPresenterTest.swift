//
//  WeatherListCellPresenterTest.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import XCTest
@testable import Weather_Logger


class WeatherListCellPresenterTest: XCTestCase {
    
    //MARK: - Properties
    
    var presenter: WeatherListCellPresenterImplementation!
    let view = WeatherListCellViewSpy()
    
    //MARK: - Set up
    
    override func setUp() {
        super.setUp()
        
        presenter = WeatherListCellPresenterImplementation(view: view)
    }
    
    //MARK: - Tests
    
    func test_prepareDeleteButtonForChangedState_lower_than_zero() {
        //Given
        let expectedPoint = CGPoint(x: -20, y: 0)
        let expectedResult: CGFloat = -8
        
        //When
        presenter.prepareDeleteButtonForChangedStateWith(point: expectedPoint)
        
        //Then
        XCTAssertEqual(expectedResult, view.deleteConstraintValue)
    }
    
    func test_prepareDeleteButtonForChangedState_greater_than_zero() {
        //Given
        let expectedPoint = CGPoint(x: 20, y: 0)
        let expectedResult: CGFloat = 0
        
        //When
        presenter.prepareDeleteButtonForChangedStateWith(point: expectedPoint)
        
        //Then
        XCTAssertEqual(expectedResult, view.deleteConstraintValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_zero_state() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = 0
        let expectedCurrentMovingViewCenterValue: CGFloat = 0
        let expectedViewValue: CGFloat = 0
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_LastSwiped_greater_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = 20
        let expectedCurrentMovingViewCenterValue: CGFloat = 0
        let expectedViewValue: CGFloat = 0
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_CurrentMoving_greater_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = 0
        let expectedCurrentMovingViewCenterValue: CGFloat = 20
        let expectedViewValue: CGFloat = 0
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_both_values_greater_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = 20
        let expectedCurrentMovingViewCenterValue: CGFloat = 20
        let expectedViewValue: CGFloat = 0
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_CurrentMoving_lower_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = 0
        let expectedCurrentMovingViewCenterValue: CGFloat = -20
        let expectedViewValue: CGFloat = -60
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_LastSwiped_lower_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = -20
        let expectedCurrentMovingViewCenterValue: CGFloat = 0
        let expectedViewValue: CGFloat = 0
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_prepareDeleteButtonForFinishedState_both_values_lower_than_zero() {
        //Given
        let expectedLastSwipedConstraintValue: CGFloat = -20
        let expectedCurrentMovingViewCenterValue: CGFloat = -20
        let expectedViewValue: CGFloat = -60
        
        presenter.lastSwipedConstraintValue = expectedLastSwipedConstraintValue
        presenter.currentMovingViewCenterValue = expectedCurrentMovingViewCenterValue
        
        //When
        presenter.prepareDeleteButtonForFinishedState()
        
        //Then
        XCTAssertEqual(view.deleteConstraintValue, expectedViewValue)
    }
    
    func test_swipeGesureShouldBegin() {
        //Given
        let expectedVelocityPoint = CGPoint(x: 20, y: 60)
        view.velocityValue = expectedVelocityPoint
        
        let expectedShoudlBeganValue = false
        
        //When
        let result = presenter.swipeGesureShouldBegin
        
        //Then
        XCTAssertEqual(expectedShoudlBeganValue, result)
    }
    
    func test_showDetaails_click() {
        //Given
        let listView = WeatherListViewSpy()
        let listPresenter = WeatherListPresenterImplementation(view: listView)
        listPresenter.dataSource = WeatherModel.createModelsArray(count: 1)
        let expectedModel = listPresenter.dataSource.first!
        
        let detailsView = WeatherDetailsViewSpy()
        let detailsPresenter = WeatherDetailsPresenterImplementation(view: detailsView, model: nil)
        detailsView.presenter = detailsPresenter
        listPresenter.delegate = detailsPresenter
        
        presenter.delegate = listPresenter
        presenter.index = 0

        
        //When
        presenter.detailsButtonTapped()
        
        //Then
        XCTAssert(listView.isDetailsShowed)
        XCTAssert(detailsPresenter.model === expectedModel)
    }
}
