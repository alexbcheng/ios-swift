//
//  ViewController.swift
//  iAddit
//
//  Created by alex cheng on 6/30/16.
//  Copyright © 2016 aboni llc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtView.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPressTemp(sender: UIButton) {
        print("leftNumStr=\(leftNumStr)\r\n",
              "leftNum=\(leftNum)\r\n",
            "rightNumStr=\(rightNumStr)\r\n",
            "rightNum=\(rightNum)\r\n",
            "operation=\(operationStr)\r\n")
    }
    
    @IBOutlet weak var txtView: UITextView!
    var leftNumStr : String = ""
    var rightNumStr: String = ""
    var leftNum = 0.0
    var rightNum = 0.0
    var operationStr = ""

    @IBAction func onPressNumber(sender: UIButton) {
        let numStr = CInt(sender.tag) < 10 ? "\(sender.tag)" : "."
        if operationStr != "" {
            rightNumStr += numStr
        } else {
            leftNumStr += numStr
        }
        txtView.text! += numStr
        let range = NSMakeRange(txtView.text.characters.count, 0)
        txtView.scrollRangeToVisible(range)
    }
    @IBAction func onPressClear(sender: UIButton) {
        leftNumStr = ""
        rightNumStr = ""
        txtView.text = ""
        leftNum = 0.0
        rightNum = 0.0
        operationStr = ""
    }
    @IBAction func onPressOperation(sender: UIButton) {
        
        if sender.tag == 1000 && leftNum != 0 && operationStr != "" {
            rightNum = rightNumStr == "" ? 0 : CDouble(rightNumStr)!
            leftNum = performOperation(operationStr, lNum: leftNum, rNum: rightNum)
            leftNumStr = "\(leftNum)"
            txtView.text! += "= \r\n \(leftNum)"
            rightNumStr = ""
            operationStr = ""
        } else {
            switch sender.tag {
            case 1001:
                operationStr = "add"; txtView.text! += "+ \r\n"
            case 1002:
                operationStr = "subtract"; txtView.text! += "- \r\n"
            case 1003:
                operationStr = "multiply"; txtView.text! += "x \r\n"
            case 1004:
                operationStr = "divide"; txtView.text! += "/ \r\n"
            default:
                return
            }
            leftNum = leftNumStr == "" ? 0 : CDouble(leftNumStr)!
            rightNum = rightNumStr == "" ? 0 : CDouble(rightNumStr)!
            leftNum = performOperation(operationStr, lNum: leftNum, rNum: rightNum)
            leftNumStr = "\(leftNum)"
            rightNumStr = ""
        }
        let range = NSMakeRange(txtView.text.characters.count, 0)
        txtView.scrollRangeToVisible(range)
    }
    
    func performOperation(operation: String, lNum: Double, rNum: Double) -> Double {
        switch operation {
        case "add":
            return lNum + rNum
        case "subtract":
            return lNum - rNum
        case "multiply":
            return lNum * (rNum == 0 ? 1 : rNum)
        case "divide":
            return lNum / (rNum == 0 ? 1 : rNum)
        default:
            return 0.0
        }
    }
}

