//
//  ViewController.swift
//  Dicee
//
//  Created by alex cheng on 3/20/18.
//  Copyright © 2018 aboni llc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var randomDiceIndex0 : Int = 0
    var randomDiceIndex1 : Int = 0
    
    let diceArray = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    
    @IBOutlet weak var diceImage0: UIImageView!
    @IBOutlet weak var diceImage1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDiceFace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func rollButtonPressed(_ sender: UIButton) {
        updateDiceFace()
    }
    
    func updateDiceFace() {
        randomDiceIndex0 = Int(arc4random_uniform(6))
        randomDiceIndex1 = Int(arc4random_uniform(6))
        
        diceImage0.image = UIImage.init(named: diceArray[randomDiceIndex0])
        diceImage1.image = UIImage.init(named: diceArray[randomDiceIndex1])

        print("\(diceArray[randomDiceIndex0]) \("and") \(diceArray[randomDiceIndex1])")
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        updateDiceFace()
    }
    
}

