//
//  Calculator1ViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 15/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit

class Calculator1ViewController: UIViewController {

    @IBOutlet weak var addaromeLabel: UILabel! // affichage ajout d'arome 1
    @IBOutlet weak var addaromeLabel2: UILabel! // affichage ajout d'arome 2
    @IBOutlet weak var addnicotineLabel: UILabel! // affichage ajout nicotine
    @IBOutlet weak var finalbaseLabel: UILabel! // contenance final du mélange
    @IBOutlet weak var finalnicotineLabel: UILabel! // taux de nicotine final du mélange
    
    @IBOutlet weak var baseLabel: UITextField! //chiffre de la base sans nicotine
    @IBOutlet weak var aromeLabel: UITextField! // chiffre du pourcentage d'arome 1
    @IBOutlet weak var aromeLabel2: UITextField! // chiffre du pourcentage d'arome 2
    @IBOutlet weak var nicotineLabel: UITextField! // taux de nicotine souhaité
    
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
        guard let nicotine = Double(nicotineLabel.text!) else {
            return
        }
        
        //print("base : \(base) , arome : \(arome) , nicotine :\(nicotine)")
        
        let arometoadd1 = arome * base / 100
        let arometoadd2 = arome2 * base / 100
        let nicotinetoadd = (base+arometoadd1+arometoadd2) * nicotine / 20
        let finalbase = base + arometoadd1 + arometoadd2 + nicotinetoadd
        
        addaromeLabel.text = String(arometoadd1)
        addaromeLabel2.text = String(arometoadd2)
        addnicotineLabel.text = String(nicotinetoadd)
        finalbaseLabel.text = String(finalbase)
        finalnicotineLabel.text = String(nicotine)
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


