//
//  MenuCalculatorViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 24/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit
import Firebase

class MenuCalculatorViewController: UIViewController {
    
    @IBOutlet weak var calculatorWithoutNicotine: UIButton! {
        didSet {
            calculatorWithoutNicotine.layer.cornerRadius = 15
            calculatorWithoutNicotine.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var calculatorwithnicotine: UIButton! {
        didSet {
            calculatorwithnicotine.layer.cornerRadius = 15
            calculatorwithnicotine.layer.borderWidth = 1
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
