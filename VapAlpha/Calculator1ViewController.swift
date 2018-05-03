//
//  Calculator1ViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 15/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit

class Calculator1ViewController: UIViewController, UITextFieldDelegate {

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
        
        setGestureRecognizersToDismissKeyboard()
        
        baseLabel.delegate = self
        aromeLabel.delegate = self
        aromeLabel2.delegate = self
        nicotineLabel.delegate = self
        
        baseLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        aromeLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        aromeLabel2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        nicotineLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        _ = baseLabel.text
        _ = aromeLabel.text
        _ = aromeLabel2.text
        _ = nicotineLabel.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case baseLabel:
            baseLabel.resignFirstResponder()
            break
        case aromeLabel:
            aromeLabel.resignFirstResponder()
            break
        case aromeLabel2:
            aromeLabel2.resignFirstResponder()
            break
        case nicotineLabel:
            nicotineLabel.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    
    
    ///////////////////////////////Hide Keyboard//////////////////////////////////////
    
    @IBAction func unwindToLogin(storyboard: UIStoryboardSegue){}
    
    // Dismissing the Keyboard with the Return Keyboard Button
    @objc func dismissKeyboard(gesture: UIGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func setGestureRecognizersToDismissKeyboard(){
        
        // Creating Tap Gesture to dismiss Keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Calculator1ViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(Calculator1ViewController.dismissKeyboard(gesture:)))
        swipDown.direction = .down
        view.addGestureRecognizer(swipDown)
    }
    
    // Moving the View down after the Keyboard appears
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateView(up: true, moveValue: 45)
    }
    
    // Moving the View down after the Keyboard disappears
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateView(up: false, moveValue: 45)
    }
    
    // Move the View Up & Down when the Keyboard appears
    func animateView(up: Bool, moveValue: CGFloat){
        
        let movementDuration: TimeInterval = 0.3
        let movement: CGFloat = (up ? -moveValue : moveValue)
        UIView.beginAnimations("animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

}


