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
    
    @IBAction func onPressTemp(_ sender: UIButton) {
        print("leftNumStr=\(leftNumStr)\r\n",
              "leftNum=\(leftNum)\r\n",
            "rightNumStr=\(rightNumStr)\r\n",
            "rightNum=\(rightNum)\r\n",
            "currNum=\(currNumStr)\r\n",
            "operation=\(operationStr)\r\n")
    }
    
    @IBOutlet weak var txtView: UITextView!
    let operation = [1000:"=", 1001:"+", 1002:"-", 1003:"*", 1004:"/"]
    var leftNumStr : String = ""
    var rightNumStr: String = ""
    var leftNum = 0.0
    var rightNum = 0.0
    var operationStr = ""
    var currNumStr = ""
    var allCleared = true

    @IBAction func onPressNumber(_ sender: UIButton) {
        if sender.tag == 10 && currNumStr.contains(".") {
            return
        }
        var numStr = CInt(sender.tag) < 10 ? "\(sender.tag)" : "."
        if operationStr != "" {
            if rightNumStr.count == 0 && numStr == "." {
                numStr = "0."
            }
            rightNumStr += numStr
        } else {
            if leftNumStr.count == 0 && numStr == "." {
                numStr = "0."
            }
            if leftNumStr.count != 0 && !allCleared {
                return
            }
            leftNumStr += numStr
        }
        currNumStr += numStr
        txtView.text! += numStr
        
        txtView.scrollRangeToVisible(NSMakeRange(txtView.text.count, NSMaxRange(NSMakeRange(txtView.text.count, 0))))
    }
    @IBAction func onPressClear(_ sender: UIButton) {
        leftNumStr = ""
        rightNumStr = ""
        txtView.text = ""
        leftNum = 0.0
        rightNum = 0.0
        operationStr = ""
        currNumStr = ""
        allCleared = true
    }
    @IBAction func onPressOperation(_ sender: UIButton) {
        if sender.tag == 1000 && leftNum != 0 && operationStr != "" {
            rightNum = rightNumStr == "" ? 0 : CDouble(rightNumStr)!
            leftNum = performOperation(operationStr, lNum: leftNum, rNum: rightNum)
            txtView.text! += "= \r\n \(leftNum)"
            operationStr = ""
            currNumStr = "\(leftNum)"
            allCleared = false
        } else {
            operationStr = operation[sender.tag]!
            if operationStr == operation[1000] {
                operationStr = ""
                return
            }
            txtView.text! += "\(operationStr) \r\n"
            leftNum = leftNumStr == "" ? 0 : CDouble(leftNumStr)!
            rightNum = rightNumStr == "" ? 0 : CDouble(rightNumStr)!
            leftNum = performOperation(operationStr, lNum: leftNum, rNum: rightNum)
            currNumStr = ""
        }
        leftNumStr = "\(leftNum)"
        rightNumStr = ""
        
        txtView.scrollRangeToVisible(NSMakeRange(txtView.text.count, NSMaxRange(NSMakeRange(txtView.text.count, 0))))
    }
    
    func performOperation(_ operation: String, lNum: Double, rNum: Double) -> Double {
        switch operation {
        case "+":
            return lNum + rNum
        case "-":
            return lNum - rNum
        case "*":
            return lNum * (rNum == 0 ? 1 : rNum)
        case "/":
            return lNum / (rNum == 0 ? 1 : rNum)
        default:
            return 0.0
        }
    }
    
    @IBAction func onPressNegPos(_ sender: UIButton) {
        if operationStr != "" {
            rightNumStr = "\(CDouble(rightNumStr)! * -1)"
        } else {
            leftNumStr = "\(CDouble(leftNumStr)! * -1)"
        }
        currNumStr = "\(CDouble(currNumStr)! * -1)"
        //txtView.text! += let tS = String(repeating: "\\b", count: count(currNumStr))
    }
    
}

