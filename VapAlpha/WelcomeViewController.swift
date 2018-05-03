//
//  WelcomeViewController.swift
//  VapAlpha
//
//  Created by Anthony Goncalves on 27/04/2018.
//  Copyright © 2018 Anthony Goncalves. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FacebookCore
import FacebookLogin
import LBTAComponents
import JGProgressHUD
import SwiftyJSON


class WelcomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton! {
        didSet {
            loginButton.layer.cornerRadius = 15
            loginButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var createAccountButton: UIButton! {
        didSet {
            createAccountButton.layer.cornerRadius = 15
            createAccountButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var signInWithFacebook: UIButton! {
        didSet {
            signInWithFacebook.layer.cornerRadius = 15
            signInWithFacebook.layer.borderWidth = 1
        }
    }
    
    
    var name: String?
    var email: String?
    var profilePicture: UIImage? = #imageLiteral(resourceName: "profilePictureWhite")
    
    let hud: JGProgressHUD = {
        let hud = JGProgressHUD(style: .light)
        hud.interactionType = .blockAllTouches
        return hud
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func SignupWithFb(_ sender: Any) {
        hud.textLabel.text = "Connexion avec Facebook..."
        hud.show(in: view, animated: true)
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                self.signIntoFirebase()
            case .failed(let err):
                Service.dismissHud(self.hud, text: "Error", detailText: "Failed to get Facebook user with error: \(err)", delay: 3)
            case .cancelled:
                Service.dismissHud(self.hud, text: "Error", detailText: "Canceled getting Facebook user", delay: 3)
            }
        }
    }
    
    fileprivate func signIntoFirebase() {
        guard let authenticationToken = AccessToken.current?.authenticationToken else { return }
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: authenticationToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, err) in
            if let err = err {
                Service.dismissHud(self.hud, text: "Sign up error", detailText: err.localizedDescription, delay: 3)
                self.hud.dismiss(animated: true)
                return
            }
            print("Succesfully authenticated with Firebase.")
            self.fetchFacebookUser()
        }
    }
    
    fileprivate func fetchFacebookUser() {
        let graphRequestConnection = GraphRequestConnection()
        let graphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, picture.type(large)"], accessToken: AccessToken.current, httpMethod: .GET, apiVersion: .defaultVersion)
        graphRequestConnection.add(graphRequest) { (httpResponse, result) in
            switch result {
            case .success(response: let response):
                guard let responseDictionary = response.dictionaryValue else { return }
                
                let json = JSON(responseDictionary)
                self.name = json["name"].string
                self.email = json["email"].string
                
                guard let profilePictureUrl = json["picture"]["data"]["url"].string, let url = URL(string: profilePictureUrl) else { return }
                
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    guard let data = data else { return }
                    self.profilePicture = UIImage(data:data)
                    self.saveUserIntoFirebase()
                }).resume()
                break
            case .failed(let err):
                print(err)
                break
            }
        }
        graphRequestConnection.start()
    }
    
    fileprivate func saveUserIntoFirebase() {
        let fileName = UUID().uuidString
        guard let profilePicture = self.profilePicture else { return }
        guard let uploadData = UIImageJPEGRepresentation(profilePicture, 0.3) else { return }
        FIRStorage.storage().reference().child("profileImages").child(fileName).put(uploadData, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
                return
            }
            print("Successfully saved profile image into Firebase Storage.")
            
            guard let profilePictureUrl = metadata?.downloadURL()?.absoluteString else { return }
            guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
            
            let dictionaryValues = ["name": self.name,
                                    "email": self.email,
                                    "profileImageUrl": profilePictureUrl]
            
            let values = [uid: dictionaryValues]
            
            FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                if let err = err {
                    print(err)
                    return
                }
                print("Successfully saved user into Firebase Database.")
                self.hud.dismiss(animated: true)
                self.performSegue(withIdentifier: "toHomeScreen", sender: self)
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = FIRAuth.auth()?.currentUser {
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
}
