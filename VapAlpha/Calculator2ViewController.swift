//
//  Calculator2ViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 25/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit

class Calculator2ViewController: UIViewController, UITextFieldDelegate {

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
        
        setGestureRecognizersToDismissKeyboard()
        
        baseLabel.delegate = self
        aromeLabel.delegate = self
        aromeLabel2.delegate = self
        
        baseLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        aromeLabel.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        aromeLabel2.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        _ = baseLabel.text
        _ = aromeLabel.text
        _ = aromeLabel2.text
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Calculator2ViewController.dismissKeyboard(gesture:)))
        tapGesture.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapGesture)
        
        // Creating Swipe Gesture to dismiss Keyboard
        let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(Calculator2ViewController.dismissKeyboard(gesture:)))
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
