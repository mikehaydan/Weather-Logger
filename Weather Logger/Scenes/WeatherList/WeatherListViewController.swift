//
//  WeatherListViewController.swift
//  Weather Logger
//
//  Created by Mike Haydan on 11/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherListViewController: UIViewController {

    //MARK: - Properties
    
    private var presenter: WeatherListPresenter!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = WeatherListPresenterImplementation(view: self)
    }
    
    //MARK: - IBActions
    
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public

}

//MARK: - WeatherListView

extension WeatherListViewController: WeatherListView {
    
    func showWithRetry(message: String, retryText: String, retryHandler: @escaping () -> ()) {
        alert(message: message, okText: retryText, okHandler: { (_) in
            retryHandler()
        })
    }
    
    func show(message: String) {
        alert(message: message)
    }
    
    func reloadView() {
        
    }
    
    func showProgres() {
        
    }
    
    func hideProgres() {
        
    }
}
