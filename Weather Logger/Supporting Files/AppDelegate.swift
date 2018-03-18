//
//  AppDelegate.swift
//  Weather Logger
//
//  Created by Mike Haydan on 10/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    //MARK: - Properties
    
    var window: UIWindow?

    //MARK: - AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        prepareSplitController()
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStackImpementation.shared.saveContext()
    }

    //MARK: - Private

    private func prepareSplitController() {
        guard let splitViewController = window?.rootViewController as? SplitViewController,
            let masterNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = masterNavController.topViewController as? WeatherListViewController,
            let detailsController = splitViewController.viewControllers.last as? WeatherDetailsViewController else {
                fatalError()
        }
      
        let weatherListPresenter = WeatherListPresenterImplementation(view: masterViewController)
        masterViewController.presenter = weatherListPresenter
        let weatherDetailsPresenter = WeatherDetailsPresenterImplementation(view: detailsController, model: nil)
        detailsController.presenter = weatherDetailsPresenter
//        detailsViewController.navigationItem.leftItemsSupplementBackButton = true
//        detailsViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        
        weatherListPresenter.delegate = weatherDetailsPresenter
    }

}

