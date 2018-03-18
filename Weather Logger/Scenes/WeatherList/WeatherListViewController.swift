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
    
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: WeatherListPresenter!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.prepareDataSource()
    }
    
    //MARK: - IBActions
    
    
    //MARK: - Private
    
    
    
    //MARK: - Public
}


//MARK: - UITableViewDataSource

extension WeatherListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: presenter.weatherCellIndetifier, for: indexPath) as! WeatherListTableViewCell
        presenter.configure(view: cell, atIndex: indexPath.row)
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension WeatherListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(presenter.cellHeight)
    }
}

//MARK: - WeatherListView

extension WeatherListViewController: WeatherListView {
    
    func showWithRetry(message: String, retryText: String, retryHandler: @escaping () -> ()) {
        alert(message: message, okText: retryText, okHandler: { (_) in
            retryHandler()
        }, cancelHandler: {(_) in
            
        })
    }
    
    func show(message: String) {
        alert(message: message)
    }
    
    func reloadView() {
        tableView.reloadData()
    }
    
    func showProgres() {
        activityIndicator.startAnimating()
    }
    
    func hideProgres() {
        activityIndicator.stopAnimating()
    }
    
    func showDetailsViewWith(model: WeatherApiModel, forView view: WeatherDetailsView) {
        let detailsViewController = view as! WeatherDetailsViewController
        let navigationController = detailsViewController.navigationController!
        
        presenter.configure(view: detailsViewController, withModel: model)
        
        splitViewController!.showDetailViewController(navigationController, sender: nil)
    }
}
