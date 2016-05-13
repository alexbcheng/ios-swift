//
//  ChildListTableViewCell.swift
//  demo01
//
//  Created by alex cheng on 3/16/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit

class ChildListTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var itemTextField: UITextField!
    var parentKey: String!
    var isDone = false
    var inEditMode = false
    var originalCenter = CGPoint()
    var createdTS: NSDate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.textLabel?.font = UIFont.systemFontOfSize(14)
        let recognizer = UIPanGestureRecognizer(target: self, action: "handlePan:")
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
        itemTextField.borderStyle = .None
        itemTextField.enabled = false
        itemTextField.delegate = self
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let success = appDelegate.dataController.addItem("Listings", text: textField.text!, parentKey: self.parentKey)
        if success {
            let navController = UIApplication.sharedApplication().windows[0].rootViewController as? UINavigationController
            let viewController = navController?.viewControllers[1] as? ChildListTableViewController
            viewController?.refreshViewAfterInsert(textField.text!, parentKey: self.parentKey)
            textField.becomeFirstResponder()
        }
        return success
    }
    
    func handlePan(recognizer: UIPanGestureRecognizer) {
        if recognizer.state == .Began && inEditMode == false {
            originalCenter = center
        }
        if recognizer.state == .Changed && inEditMode == false {
            let translation = recognizer.translationInView(self)
            center = CGPointMake(originalCenter.x + translation.x, originalCenter.y)
        }
        if recognizer.state == .Ended && inEditMode == false {
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                width: bounds.size.width, height: bounds.size.height)
            UIView.animateWithDuration(0.2, animations: {self.frame = originalFrame})
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.dataController.updateItemAsDone(self.itemTextField.text!, parentKey: self.parentKey)
            let navController = UIApplication.sharedApplication().windows[0].rootViewController as? UINavigationController
            let viewController = navController?.viewControllers[1] as? ChildListTableViewController
            viewController?.refreshView()
        }
    }
    
}
