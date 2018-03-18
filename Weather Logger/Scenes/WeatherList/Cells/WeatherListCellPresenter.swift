//
//  WeatherListCellPresenter.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

private struct WeatherListCellPresenterConstants {
    static let minSwipeDifference: CGFloat = 13
    static let deleteButtonWidth: CGFloat = 60
}

protocol WeatherListCellDelegate: class {
    func detailsButtonTappedAt(index: Int)
    func deleteButtonTappedAt(index: Int)
}

protocol WeatherListCellPresenter {
    var swipeGesureShouldBegin: Bool { get }
    init(view: WeatherListCellView)
    func detailsButtonTapped()
    func configureWith(model: WeatherApiModel, delegate: WeatherListCellDelegate?, atIndex index: Int)
    func prepareDeleteButtonForChangedStateWith(point: CGPoint)
    func prepareDeleteButtonForFinishedState()
    func deletButtonTapped()
}

protocol WeatherListCellView: class {
    var presenter: WeatherListCellPresenter! { get }
    var velocityInView: CGPoint { get }
    func set(temperature: String, andDate date: String)
    func set(detailsButtonText: String)
    func prepareGesture()
    func setDeleteButtonConstraintWith(value: CGFloat)
    func reloadViewAnimated()
    func setGesture(enabled: Bool)
}

class WeatherListCellPresenterImplementation: WeatherListCellPresenter {
    
    //MARK: - Properties
    
    private var lastSwipedConstraintValue: CGFloat = 0
    
    private var currentDeleteButtonValue: CGFloat = 0
    
    unowned let view: WeatherListCellView
    
    weak var delegate: WeatherListCellDelegate?
    
    var index: Int!
    
    var swipeGesureShouldBegin: Bool {
        let velocity = view.velocityInView
        return fabs(velocity.y) < fabs(velocity.x)
    }
    
    //MARK: - LifeCycle
    
    required init(view: WeatherListCellView) {
        self.view = view
        
        self.view.prepareGesture()
    }
    
    //MARK: - Private
    
    
    
    //MARK: - Public
    
    func configureWith(model: WeatherApiModel, delegate: WeatherListCellDelegate?, atIndex index: Int) {
        self.index = index
        self.delegate = delegate
        let dateFormater = DateFormatter()
        dateFormater.dateStyle = .short
        dateFormater.timeStyle = .medium
        let stringDate = dateFormater.string(from: Date())
        let gestureEnabled = model.coreDataModel != nil
        view.setGesture(enabled: gestureEnabled)
        view.set(temperature: "\(model.main.temp) °C", andDate: stringDate)
    }
    
    func detailsButtonTapped() {
        delegate?.detailsButtonTappedAt(index: index)
    }
    
    func prepareDeleteButtonForChangedStateWith(point: CGPoint) {
        let newPoint = lastSwipedConstraintValue + point.x * 0.4
        let value: CGFloat = newPoint <= 0 ? newPoint : 0
        view.setDeleteButtonConstraintWith(value: value)
        currentDeleteButtonValue = value
    }
    
    func prepareDeleteButtonForFinishedState() {
        if lastSwipedConstraintValue < currentDeleteButtonValue && (currentDeleteButtonValue - lastSwipedConstraintValue) > WeatherListCellPresenterConstants.minSwipeDifference {
            view.setDeleteButtonConstraintWith(value: 0)
            currentDeleteButtonValue = 0
        } else {
            currentDeleteButtonValue = -WeatherListCellPresenterConstants.deleteButtonWidth
            view.setDeleteButtonConstraintWith(value: currentDeleteButtonValue)
        }
        lastSwipedConstraintValue = currentDeleteButtonValue
    }
    
    func deletButtonTapped() {
        delegate?.deleteButtonTappedAt(index: index)
    }
}
