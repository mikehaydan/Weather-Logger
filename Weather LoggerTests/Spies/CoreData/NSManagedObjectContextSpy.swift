//
//  NSManagedObjectContextSpy.swift
//  Weather LoggerTests
//
//  Created by Mike Haydan on 20/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreData
@testable import Weather_Logger


class NSManagedObjectContextSpy: NSManagedObjectContextProtocol {

    var enititiesToReturn: [Any]?
    var saveErrorToReturn: Error?
    var deletedObject: NSManagedObject?
    var addEntityToReturn: Any?
    
    func allEntities<T>(withType type: T.Type) -> [T] where T : NSManagedObject {
        return allEntities(withType: type, predicate: nil)
    }
    
    func allEntities<T>(withType type: T.Type, predicate: NSPredicate?) -> [T] where T : NSManagedObject {
        if let enititiesToReturn = enititiesToReturn {
            return enititiesToReturn as! [T]
        } else {
            return []
        }
    }
    
    func addEntity<T>(withType type: T.Type) -> T? where T : NSManagedObject {
        return addEntityToReturn as? T
    }
    
    func save() throws {
        if let saveErrorToReturn = saveErrorToReturn {
            throw saveErrorToReturn
        }
    }
    
    func delete(_ object: NSManagedObject) {
        deletedObject = object
    }
}
