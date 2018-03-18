//
//  NSManagedObjectContext + Extensions.swift
//  Weather Logger
//
//  Created by Mike Haydan on 15/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//

import Foundation
import CoreData

protocol NSManagedObjectContextProtocol {
    func allEntities<T: NSManagedObject>(withType type: T.Type) -> [T]
    func allEntities<T: NSManagedObject>(withType type: T.Type, predicate: NSPredicate?) -> [T]
    func addEntity<T: NSManagedObject>(withType type: T.Type) -> T?
    func save() throws
    func delete(_ object: NSManagedObject)
}

extension NSManagedObjectContext: NSManagedObjectContextProtocol {

    func allEntities<T>(withType type: T.Type, predicate: NSPredicate?) -> [T] where T : NSManagedObject {
        let request = NSFetchRequest<T>(entityName: String(describing: T.self))
        request.predicate = predicate
        if let result = try? self.fetch(request) {
            return result
        } else {
            return []
        }
    }
    
    func allEntities<T>(withType type: T.Type) -> [T] where T : NSManagedObject {
        return allEntities(withType: type, predicate: nil)
    }
    
    func addEntity<T>(withType type: T.Type) -> T? where T : NSManagedObject {
        if let entity = NSEntityDescription.entity(forEntityName: String(describing: T.self), in: self) {
            let record = T(entity: entity, insertInto: self)
            return record
        } else {
            return nil
        }
    }
}
