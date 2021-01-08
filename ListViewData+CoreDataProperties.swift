//
//  ListViewData+CoreDataProperties.swift
//  
//
//  Created by 임현규 on 2021/01/06.
//
//

import Foundation
import CoreData


extension ListViewData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ListViewData> {
        return NSFetchRequest<ListViewData>(entityName: "ListViewData")
    }

    @NSManaged public var time: String?
    @NSManaged public var stateName: String?
    @NSManaged public var temperature: String?
    @NSManaged public var backgrounTime: String?
}
