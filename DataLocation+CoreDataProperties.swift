//
//  DataLocation+CoreDataProperties.swift
//  
//
//  Created by 임현규 on 2021/01/06.
//
//

import Foundation
import CoreData


extension DataLocation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DataLocation> {
        return NSFetchRequest<DataLocation>(entityName: "DataLocation")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var stateName: String?

}
