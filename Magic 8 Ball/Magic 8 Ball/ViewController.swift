//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by alex cheng on 3/21/18.
//  Copyright © 2018 aboni llc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageBall: UIImageView!
    var ballImages = ["ball1","ball2","ball3","ball4","ball5"]
    var randomBallNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update8BallFace()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func askButtonPressed(_ sender: UIButton) {
        update8BallFace()
    }
    
    func update8BallFace() {
        randomBallNum = Int(arc4random_uniform(4))
        imageBall.image = UIImage.init(named: ballImages[randomBallNum])
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        update8BallFace()
    }
    
}

