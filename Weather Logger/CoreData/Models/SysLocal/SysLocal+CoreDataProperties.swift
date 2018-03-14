//
//  SysLocal+CoreDataProperties.swift
//  Weather Logger
//
//  Created by Mike Haydan on 13/03/2018.
//  Copyright © 2018 Mike Haydan. All rights reserved.
//
//

import Foundation
import CoreData


extension SysLocal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SysLocal> {
        return NSFetchRequest<SysLocal>(entityName: "SysLocal")
    }

    @NSManaged public var id: Int64
    @NSManaged public var type: String?
    @NSManaged public var message: Float
    @NSManaged public var country: String?
    @NSManaged public var sunrise: Double
    @NSManaged public var sunset: Double
    @NSManaged public var weatherLocalModel: WeatherLocalModel?

}
