//
//  AuthService.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/8/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Kingfisher

class AuthService {
    
    static let instance = AuthService()
    
    //MARK:- REGISTER FOR NEW USER
    func registerForNewUser(withEmail email : String , andPassword password : String ,andFirstName firstName : String , andLastName lastName : String ,registerCompleted : @escaping(_ success : Bool , _ error : Error?)->Void ){
        Auth.auth().createUser(withEmail: email, password: password) { (registerResult, error) in
            
            guard let registerResult = registerResult else {
                registerCompleted(false,error)
                return
            }
            
            let uid = registerResult.user.uid
            let userData = ["First Name" : firstName ,
                            "Last Name" : lastName ,
                            "Email" : email ,
                            "Provider" : "Firebase" ]
            
            DataService.instance.createUser(uid: uid, userData: userData)
            registerCompleted(true,nil)
        }
    }
    
    
    //MARK:- LOGIN FOR CURRENT USER
    func loginForCurrentUser(withEmail email : String , andPassword password : String ,loginCompleted : @escaping(_ success : Bool , _ error : Error?)->Void ){
        
        Auth.auth().signIn(withEmail: email, password: password) { (loginResult, error) in
            
            if error != nil {
                loginCompleted(false,error)
                return
            }
            loginCompleted (true,nil)
        }
    }
    
    
    //MARK:- LOGIN USING FACEBOOK
    func facebookLogin (loginCompleted : @escaping(_ success : Bool , _ error : Error?)->Void) {
        var myUrl : String?
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        // Perform login by calling Firebase APIs
        Auth.auth().signInAndRetrieveData(with: credential) { (fbLoginResult, error) in
            
            guard let fbLoginResult = fbLoginResult else {
                loginCompleted(false,error)
                return
            }
            
            
            
            let fullName = fbLoginResult.user.displayName
            var fullNameArr = fullName!.split{$0 == " "}.map(String.init)
            let firstName: String = fullNameArr[0]
            let lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
            
            
            let userData = ["First Name" : firstName ,
                            "Last Name" : lastName ,
                            "Email" : fbLoginResult.user.email ,
                            "Provider" : "Facebook" ]
            DataService.instance.uploadProfilePic()
            
            DataService.instance.createUser(uid: fbLoginResult.user.uid , userData: userData as! [String : String])
            loginCompleted(true,nil)
        }
    }
    
    
    
    
    //MARK:- LOGIN USING GOOGLE
    func googleLogin(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error! , loginCompleted : @escaping(_ success : Bool , _ error : Error?)->Void) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
        
        // When user is signed in
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (googleLoginResult, error) in
            
            guard let googleLoginResult = googleLoginResult else {
                loginCompleted(false,error)
                return
            }
            
            let fullName = googleLoginResult.user.displayName
            var fullNameArr = fullName!.split{$0 == " "}.map(String.init)
            let firstName: String = fullNameArr[0]
            let lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
            
            let userData = ["First Name" : firstName ,
                            "Last Name" : lastName ,
                            "Email" : googleLoginResult.user.email ,
                            "Provider" : "Google" ]
            
            DataService.instance.createUser(uid: googleLoginResult.user.uid , userData: userData as! [String : String])
            loginCompleted(true,nil)
        }
        )
    }
    
    
    
//    func getFacebookImage(completion: @escaping (_ imageUrl: String?) -> Void){
//        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.width(480).height(480)"])
//        graphRequest?.start(completionHandler: { (connection, result, error) in
//            if error != nil {
//                print("Error",error!.localizedDescription)
//            }
//            else{
//                print(result!)
//                let field = result! as? [String:Any]
//                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
//                    let url = URL(string: imageURL)
//                    let dataaa = NSData(contentsOf: url!)
//                }
//            }
//        })
//    }
//    
    
    
}


