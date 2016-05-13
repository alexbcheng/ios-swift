//
//  ListCollectionViewController.swift
//  demo01
//
//  Created by alex cheng on 3/11/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "ListCollectionViewCell"

class ListCollectionViewController: UICollectionViewController {

    var fetchedResultsController: NSFetchedResultsController!
    var isEditing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //super.viewWillDisappear(animated)
    }
    
    // MARK: UICollectionViewDataSource
    
    func refreshView() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
        self.collectionView?.reloadData()        
    }
    
    @IBAction func onAddNewListItem(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Add New Item", message: "Name of new item", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            if let newItem = alertController.textFields![0].text {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.dataController.addItem("Groups", text: newItem)
                self.refreshView()
            }
        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func editListItem(oldText: String) {
        let alertController = UIAlertController(title: "Updating \(oldText)", message: "Enter new name", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            if let newText = alertController.textFields![0].text {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.dataController.updateItem("Groups", oldText: oldText, newText: newText)
                self.refreshView()
            }
        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
       
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.collectionView?.allowsSelection = editing ? false: true
        self.isEditing = editing
        self.collectionView?.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController.sections!.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ListCollectionViewCell    
        // Configure the cell
        let group = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Groups

        cell.backgroundColor = isEditing! ? UIColor.grayColor() : UIColor.yellowColor()
        cell.itemText.textColor = isEditing! ? UIColor.yellowColor() : UIColor.blackColor()
        cell.itemText.text = group.name
        cell.deleteItem.hidden = isEditing! ? false : true
        cell.editItem.hidden = isEditing! ? false : true
    
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showChildList" {
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let selectedCell = sender as! ListCollectionViewCell
            let childListVC = segue.destinationViewController as! ChildListTableViewController
            childListVC.isEditing = false
            childListVC.navigationItem.title = selectedCell.itemText.text
            childListVC.fetchedResultsController = appDelegate.dataController.fetchList("Listings", sortBy: ["isDone","created"], parentKey: selectedCell.itemText.text)
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //let cell = collectionView.cellForItemAtIndexPath(indexPath)
        //cell!.layer.borderWidth = 2.0
        //cell!.layer.borderColor = UIColor.grayColor().CGColor
    }

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
