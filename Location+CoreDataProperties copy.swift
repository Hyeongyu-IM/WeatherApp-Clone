//
//  Location+CoreDataProperties.swift
//  
//
//  Created by 임현규 on 2020/12/12.
//
//

import Foundation
import CoreData


extension DataLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataLocation> {
        return NSFetchRequest<DataLocation>(entityName: "DataLocation")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var location: [Double]?

}
