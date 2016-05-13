//
//  ListCollectionViewCell.swift
//  demo01
//
//  Created by alex cheng on 3/15/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var itemText: UILabel!
    @IBOutlet weak var deleteItem: UIButton!
    @IBOutlet weak var editItem: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editItem.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        deleteItem.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
            
    @IBAction func onDeleteItem(sender: AnyObject, forEvent event: UIEvent) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataController.deleteItem("Groups", textToDelete: self.itemText.text!)
        let navController = UIApplication.sharedApplication().windows[0].rootViewController as? UINavigationController
        let viewController = navController?.viewControllers[0] as? ListCollectionViewController
        viewController?.refreshView()
    }
    
    @IBAction func onEditItem(sender: AnyObject, forEvent event: UIEvent) {
        let navController = UIApplication.sharedApplication().windows[0].rootViewController as? UINavigationController
        let viewController = navController?.viewControllers[0] as? ListCollectionViewController
        viewController?.editListItem(self.itemText.text!)
    }
    
}
