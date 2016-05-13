//
//  DataController.swift
//  demo01
//
//  Created by alex cheng on 3/12/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    convenience init?() {
        
        guard let modelList = NSBundle.mainBundle().URLForResource("ListData", withExtension: "momd") else {
            return nil
        }
        
        guard let mom = NSManagedObjectModel(contentsOfURL: modelList) else {
            return nil
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let persistantStoreFileURL = urls[0].URLByAppendingPathComponent("ListingsData1.sqlite")
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistantStoreFileURL, options: nil)
        } catch {
            fatalError("Error adding store.")
        }
        
        self.init(moc: moc)
        
    }
    
    func fetchList(entity: String, sortBy: [String], parentKey: String?=nil) -> NSFetchedResultsController! {
        let listFetch = NSFetchRequest(entityName: entity)
        if parentKey != nil {
            listFetch.predicate = NSPredicate(format: "parentKey == %@", parentKey!)
        }
        listFetch.sortDescriptors = [NSSortDescriptor]()
        for sortKey in sortBy {
            let idSort = NSSortDescriptor(key: sortKey, ascending: true)
            listFetch.sortDescriptors?.append(idSort)
        }
        
        return NSFetchedResultsController(fetchRequest: listFetch, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }

    func addItem(entity: String, text: String, parentKey: String?=nil) -> Bool {
        let checkFetch = NSFetchRequest(entityName: entity)
        let parentFetch = NSFetchRequest(entityName: "Groups")
        if entity == "Groups" {
            checkFetch.predicate = NSPredicate(format: "name == %@", text)
        } else if entity == "Listings" {
            checkFetch.predicate = NSPredicate(format: "(name == %@) AND (parentKey == %@)", text, parentKey!)
            parentFetch.predicate = NSPredicate(format: "name == %@", parentKey!)
        }
        let numRows: Int
        do {
            numRows = try self.managedObjectContext.executeFetchRequest(checkFetch).count
        } catch {
            fatalError("fetch failed")
        }
        if numRows == 0 {
            if entity == "Groups" {
                var groups: Groups
                groups = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: self.managedObjectContext) as! Groups
                groups.name = text
            } else if entity == "Listings" {
                var parent: Groups
                var listings: Listings
                do {
                    parent = try self.managedObjectContext.executeFetchRequest(parentFetch)[0] as! Groups
                } catch {
                    fatalError("parent fetch failed")
                }
                parent.name = parentKey
                listings = NSEntityDescription.insertNewObjectForEntityForName(entity, inManagedObjectContext: self.managedObjectContext) as! Listings
                listings.name = text
                listings.parentKey = parentKey
                listings.created = NSDate()
                listings.group = parent
            }
        } else {
            print("Name already exists!")
            return false
        }
        
        do {
            try self.managedObjectContext.save()
            return true
        } catch {
            fatalError("couldn't save context")
        }
    }
    
    func deleteItem(entity: String, textToDelete: String, parentKey: String?=nil) {
        var checkFetch = NSFetchRequest(entityName: entity)
        if entity == "Groups" {
            checkFetch.predicate = NSPredicate(format: "name == %@", textToDelete)
            let groupToDelete: [Groups]
            do {
                groupToDelete = try self.managedObjectContext.executeFetchRequest(checkFetch) as! [Groups]
            } catch {
                fatalError("fetch failed")
            }
            if groupToDelete.count >= 1 {
                checkFetch = NSFetchRequest(entityName: "Listings")
                checkFetch.predicate = NSPredicate(format: "parentKey == %@", textToDelete)
                var pCnt: Int
                do {
                    pCnt = try self.managedObjectContext.executeFetchRequest(checkFetch).count
                } catch {
                    fatalError("parent fetch failed")
                }
                if pCnt == 0 {
                    self.managedObjectContext.deleteObject(groupToDelete[0])
                } else {
                    print("sub items exists")
                    return  
                }
            }
        } else if entity == "Listings" {
            checkFetch.predicate = NSPredicate(format: "(name == %@) AND (parentKey == %@)", textToDelete, parentKey!)
            let listingsToDelete: [Listings]
            do {
                listingsToDelete = try self.managedObjectContext.executeFetchRequest(checkFetch) as! [Listings]
            } catch {
                fatalError("fetch failed")
            }
            if listingsToDelete.count >= 1 {
                self.managedObjectContext.deleteObject(listingsToDelete[0])
            }
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }
    
    func updateItem(entity: String, oldText: String, newText: String) {
        let checkFetch = NSFetchRequest(entityName: entity)
        checkFetch.predicate = NSPredicate(format: "name == %@", oldText)
        let existFetch = NSFetchRequest(entityName: entity)
        existFetch.predicate = NSPredicate(format: "name == %@", newText)
        let objToUpdate: [Groups]
        let objExists: [Groups]
        do {
            objToUpdate = try self.managedObjectContext.executeFetchRequest(checkFetch) as! [Groups]
            objExists = try self.managedObjectContext.executeFetchRequest(existFetch) as! [Groups]
        } catch {
            fatalError("fetch failed")
        }
        if objExists.count > 0 {
            print("New name is already in use")
            return
        }
        if objToUpdate.count == 1 {
            if entity == "Groups" {
                let subListFetch = NSFetchRequest(entityName: "Listings")
                subListFetch.predicate = NSPredicate(format: "parentKey == %@", oldText)
                let objSubList: [Listings]
                do {
                    objSubList = try self.managedObjectContext.executeFetchRequest(subListFetch) as! [Listings]
                } catch{
                    fatalError("sub items fetch failed")
                }
                if objSubList.count > 0 {
                    for subItems in objSubList {
                        let subItemToUpdate = subItems as NSManagedObject
                        subItemToUpdate.setValue(newText, forKey: "parentKey")
                    }
                }
            }
            let itemToUpdate = objToUpdate[0] as NSManagedObject
            itemToUpdate.setValue(newText, forKey: "name")
        }
        
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
        
    }
    
    func updateItemAsDone(name: String, parentKey: String) {
        let checkFetch = NSFetchRequest(entityName: "Listings")
        checkFetch.predicate = NSPredicate(format: "(name == %@) AND (parentKey == %@)", name, parentKey)
        let itemsToUpdate: [Listings]
        do {
            itemsToUpdate = try self.managedObjectContext.executeFetchRequest(checkFetch) as! [Listings]
        } catch {
            fatalError("fetch failed")
        }
        if itemsToUpdate.count == 1 {
            let itemToMarkAsDone = itemsToUpdate[0] as NSManagedObject
            itemToMarkAsDone.setValue((itemsToUpdate[0].isDone != nil) ? (itemsToUpdate[0].isDone==1 ? false : true) : true, forKey: "isDone")
        }
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
        
    }

}
