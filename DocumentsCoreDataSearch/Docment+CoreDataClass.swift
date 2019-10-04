//
//  Docment+CoreDataClass.swift
//  DocumentsCoreDataSearch
//
//  Created by Brady Webb on 10/4/19.
//  Copyright © 2019 Brady Webb. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Docment)
public class Document: NSManagedObject {
    var modifiedDate: Date?
    {
        get
        {
            return rawModifiedDate as Date?
        }
    }
    convenience init?(name: String?, content: String?) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.init(entity: Document.entity(), insertInto: managedContext)
        self.name = name
        self.content = content
        if let size = content?.count
        {
            self.size = Int64(size)
        }
        else
        {
            self.size = 0
        }
        
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
    }
    func update(name: String, content: String?) {
        self.name = name
        self.content = content
        if let size = content?.count
        {
            self.size = Int64(size)
        }
        else
        {
            self.size = 0
        }
    
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
    }
}
