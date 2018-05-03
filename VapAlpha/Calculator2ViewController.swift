//
//  Calculator2ViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 25/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit

class Calculator2ViewController: UIViewController {

    @IBOutlet weak var addaromeLabel: UILabel! // affichage ajout d'arome
    @IBOutlet weak var finalbaseLabel: UILabel! // contenance final du mélange
    @IBOutlet weak var addaromeLabel2: UILabel! // affichage ajout d'arome 2
    
    @IBOutlet weak var baseLabel: UITextField! //chiffre de la base sans nicotine
    @IBOutlet weak var aromeLabel: UITextField! // chiffre du pourcentage d'arome
    @IBOutlet weak var aromeLabel2: UITextField! // chiffre du pourcentage d'arome 2
    
    @IBAction func calculateButton(_ sender: Any) {
        calculeeliquid()
    }
    
    func calculeeliquid() {
        guard let base = Double(baseLabel.text!) else {
            return
        }
        guard let arome = Double(aromeLabel.text!) else {
            return
        }
        guard let arome2 = Double(aromeLabel2.text!) else {
            return
        }
        
        let arometoadd = arome * base / 100
        let arometoadd2 = arome2 * base / 100
        let finalbase = base + arometoadd + arometoadd2
        
        addaromeLabel.text = String(arometoadd)
        finalbaseLabel.text = String(finalbase)
        addaromeLabel2.text = String(arometoadd2)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
