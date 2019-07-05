//
//  MainAuthVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/8/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


class MainAuthVC: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var googleBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //make curvy button
        facebookBtn.makeRoundedButton(cornerRadius: 20)
        googleBtn.makeRoundedButton(cornerRadius: 20)
        emailBtn.makeRoundedButton(cornerRadius: 20)

    }
    
    
    //MARK:- LOGIN INTO FACEBOOK BUTTON PRESSED
    @IBAction func googleBtnWasPressed(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    //MARK:- LOGIN INTO GOOGLE BUTTON PRESSED
    @IBAction func facebookBtnWasPressed(_ sender: UIButton) {
        
        let LoginManager = FBSDKLoginManager()
        showSpinner(onView: view)
        LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            AuthService.instance.facebookLogin(loginCompleted: { (sucess, error) in
                if sucess {
                    self.removeSpinner()
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                    self.present(chatRoomVC,animated: true,completion: nil)                } else {
                    self.removeSpinner()
                    self.showAltertControllerWithAction(title: "Login Error", message: error!.localizedDescription, altertStyle: .alert, actionTitle: "Okay", actionStyle: .default)
                }
            })
        }
    }
}




extension MainAuthVC : GIDSignInUIDelegate , GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        showSpinner(onView: view)
        AuthService.instance.googleLogin(signIn, didSignInFor: user, withError: error) { (success, error) in
            if success {
                self.removeSpinner()
                let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                self.present(chatRoomVC,animated: true,completion: nil)
            } else {
                self.removeSpinner()
                self.showAltertControllerWithAction(title: "Login Error", message: error!.localizedDescription, altertStyle: .alert, actionTitle: "Okay", actionStyle: .default)
            }
        }
    }
    
}
