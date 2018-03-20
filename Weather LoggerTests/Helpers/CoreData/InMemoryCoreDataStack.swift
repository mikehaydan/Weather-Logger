//
//  InMemoeyCoreDataStack.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreData

@testable import Weather_Logger

class InMemoryCoreDataStack: CoreDataStack {
    
    //MARK: - Properties
    
    static let shared = InMemoryCoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather_Logger")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    //MARK: - LifeCycle
    
    private init() {
        
    }
    
    //MARK: - Public
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
