//
//  FourthViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 15/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit
import FirebaseAuth
import LBTAComponents
import FirebaseDatabase
import FirebaseStorage

class FourthViewController: UIViewController {

    @IBOutlet weak var logOutButton: UIButton! {
        didSet {
            logOutButton.layer.cornerRadius = 15
            logOutButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var imageViewTest: UIImageView!
    
    @IBAction func handleLogout(_ sender: Any) {
        let signOutAction = UIAlertAction(title: "Déconnexion", style: .destructive) { (action) in
            do {
                try FIRAuth.auth()?.signOut()
                self.dismiss(animated: true, completion: nil)
            } catch let err {
                print("Failed to sign ou with error", err)
                Service.showAlert(on: self, style: .alert, title: "Erreur de déconnexion", message: err.localizedDescription)
            }
                
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signOutAction, cancelAction], completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //setupView()
        
        let profileImageViewHeight: CGFloat = 90
        imageViewTest.layer.cornerRadius = profileImageViewHeight / 2
        imageViewTest.clipsToBounds = true
        
        
        if FIRAuth.auth()?.currentUser != nil {
            guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            
            FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dict = snapshot.value as? [String: Any] else { return }
                
                let user = CurrentUser(uid: uid, dictionary: dict)
                
                self.usernameLabel.text = user.name
                self.emailLabel.text = user.email
            
                let imageURL = user.profileImageUrl
                
                FIRStorage.storage().reference(forURL: imageURL).data(withMaxSize: 1 * 1024 * 1024, completion: { (imgData, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            if let data = imgData {
                                self.imageViewTest.image = UIImage(data: data)
                            }
                        }
                    }else {
                        print(error!.localizedDescription)
                    }
                })
            }, withCancel: { (err) in
                print(err)
            })
            
            
        }
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
