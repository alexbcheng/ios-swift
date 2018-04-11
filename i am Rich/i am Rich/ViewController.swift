//
//  ViewController.swift
//  i am Rich
//
//  Created by alex cheng on 3/15/18.
//  Copyright © 2018 aboni llc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fibonacciText: UITextView!
    @IBOutlet weak var iterationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incrementer.value = 10
        iterationsLabel.text = "iterations: \(incrementer.value)"
        fibonacciText.text = fibonacci(until: Int(incrementer.value))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var incrementer: UIStepper!
    @IBAction func onIncrement(_ sender: UIStepper) {
        iterationsLabel.text = "iterations: \(incrementer.value)"
        fibonacciText.text = fibonacci(until: Int(incrementer.value))
    }
}

func fibonacci(until : Int) -> String {
    var curNum = 0
    var nxtNum = 1
    var fibonacciString = "\(curNum),\(nxtNum),"
    for _ in 3...until {
        let num = curNum + nxtNum
        fibonacciString += "\(num),"
        curNum = nxtNum
        nxtNum = num
    }
    return fibonacciString
}
