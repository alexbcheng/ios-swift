    //
//  ChildListTableViewController.swift
//  demo01
//
//  Created by alex cheng on 3/16/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "childCell"

class ChildListTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController!
    var isEditing: Bool!
    var isDeleting: Bool = false
    var numDataRows: Int = 0
    var listItems: [ListItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
        listItems = [ListItem]()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.isEditing = editing
        if editing {
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Top)
            self.tableView.endUpdates()
            let newItemCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ChildListTableViewCell
            newItemCell.itemTextField.text = ""
            self.tableView.reloadData()
        } else {
            let newItemCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ChildListTableViewCell
            if newItemCell.itemTextField.text?.isEmpty == false && newItemCell.itemTextField.enabled == true {
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.dataController.addItem("Listings", text: newItemCell.itemTextField.text!, parentKey: newItemCell.parentKey)
                newItemCell.itemTextField.text = ""
                newItemCell.itemTextField.enabled = false
                self.refreshView()
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    fatalError("tags fetch failed")
                }
                listItems = [ListItem]()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    func refreshView() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
        self.tableView.reloadData()
    }
    func refreshViewAfterInsert(name: String, parentKey: String) {
        listItems = [ListItem]()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
        self.tableView.reloadData()
        let newCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ChildListTableViewCell
        newCell.itemTextField.text = ""
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numDataRows = self.fetchedResultsController.sections![section].numberOfObjects + (self.isEditing! ? 1 : 0)
        return numDataRows
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ChildListTableViewCell
        // Configure the cell...
        cell.selectionStyle = .None
        cell.parentKey = self.navigationItem.title
        cell.inEditMode = isEditing!
        
        if isEditing! {
            if indexPath.row == 0 {
                cell.itemTextField.text = ""
                cell.isDone = false
            } else if indexPath.row >= 1 {
                let setIndexPath = NSIndexPath(forRow: indexPath.row-1, inSection: 0)
                let listings = self.fetchedResultsController.objectAtIndexPath(setIndexPath) as! Listings
                cell.itemTextField.enabled = false
                cell.itemTextField.text = listings.name
                cell.parentKey = listings.parentKey
                cell.isDone = listings.isDone == 1 ? true : false
                cell.createdTS = listings.created!
                listItems.append(ListItem(id: setIndexPath.row, name: listings.name!, parentKey: listings.parentKey!, isDone: false, createdTS: listings.created!))
            }
        } else {
            let listings = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Listings
            cell.itemTextField.enabled = false
            cell.itemTextField.text = listings.name
            cell.parentKey = listings.parentKey
            cell.isDone = listings.isDone == 1 ? true : false
            cell.createdTS = listings.created!
            listItems.append(ListItem(id: indexPath.row, name: listings.name!, parentKey: listings.parentKey!, isDone: false, createdTS: listings.created!))
        }
        if cell.isDone {
            cell.itemTextField.hidden = true
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.itemTextField.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            cell.textLabel?.attributedText = attributeString
            cell.textLabel?.textColor = UIColor.orangeColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
            cell.itemTextField.hidden = false
            cell.textLabel?.text = ""
            cell.textLabel?.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if indexPath.row == 0 { //numDataRows-1 {
            return UITableViewCellEditingStyle.Insert
        } else {
            return UITableViewCellEditingStyle.Delete
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.dataController.deleteItem("Listings", textToDelete: listItems[indexPath.row-1].name, parentKey: listItems[indexPath.row-1].parentKey)
            self.listItems.removeAtIndex(indexPath.row-1)
            self.refreshView()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let newCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! ChildListTableViewCell
            newCell.itemTextField.enabled = true
            newCell.itemTextField.placeholder = "Enter New Item"
            newCell.itemTextField.becomeFirstResponder()
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showItemDetails" {
            let selectedCell = sender as! ChildListTableViewCell
            let itemDetailVC = segue.destinationViewController as! ItemDetailViewController
            itemDetailVC.navigationItem.title = selectedCell.itemTextField.text
            itemDetailVC.dCreatedTS = selectedCell.createdTS
        }
    }
    

}
