//
//  Groups+CoreDataProperties.swift
//  demo01
//
//  Created by alex cheng on 4/2/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Groups {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var lists: NSSet?

}
