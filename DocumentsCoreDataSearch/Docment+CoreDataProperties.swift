//
//  Docment+CoreDataProperties.swift
//  DocumentsCoreDataSearch
//
//  Created by Brady Webb on 10/4/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//
//

import Foundation
import CoreData


extension Docment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Docment> {
        return NSFetchRequest<Docment>(entityName: "Docment")
    }

    @NSManaged public var name: String?
    @NSManaged public var size: Int64
    @NSManaged public var rawModifiedDate: NSDate?
    @NSManaged public var content: String?

}
