//
//  ItemDetailViewController.swift
//  demo01
//
//  Created by alex cheng on 4/1/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailViewController: UIViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var sLabel: UILabel!
    var dCreatedTS: NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = self.navigationItem.title
        label1.textColor = UIColor.blueColor()
        sLabel.textColor = UIColor.orangeColor()
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(label1.text!) : \(convDateToStr(dCreatedTS))")
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        sLabel.attributedText = attributeString
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convDateToStr(InDate: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm:ss"
        return dateFormatter.stringFromDate(InDate)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
