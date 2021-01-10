//
//  TempBool+CoreDataProperties.swift
//  
//
//  Created by 임현규 on 2021/01/10.
//
//

import Foundation
import CoreData


extension TempBool {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TempBool> {
        return NSFetchRequest<TempBool>(entityName: "TempBool")
    }

    @NSManaged public var tempBool: Bool
    @NSManaged public var filterName: String

}
