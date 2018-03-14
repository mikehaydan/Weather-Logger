//
//  WeatherDetailsViewController.swift
//  Weather Logger
//
//  Created by Mike Haydan on 12/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController, WeatherDetailsView {

    //MARK: - Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    var presenter: WeatherDetailsPresenter!
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.prepapreDataSource()
    }
    
    //MARK: - IBActions
    
    @IBAction private func saveButtonTapped(_ sender: Any) {
        
    }
    
    //MARK: - Public
    
    func reloadDetails() {
        tableView.reloadData()
    }
    
    func set(title: String?) {
        navigationItem.title = title
    }

}

//MARK: - UITableViewDataSource

extension WeatherDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSourceCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = presenter.getCellIdentifierAt(index: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! BaseWeatherDetailsTableViewCell
        presenter.configure(view: cell, atIndex: indexPath.row)
        
        return cell
    }
}
