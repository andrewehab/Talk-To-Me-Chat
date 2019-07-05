//
//  MeVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 7/1/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FirebaseStorage

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userID = Auth.auth().currentUser?.uid else {return}
        DataService.instance.getUserName(uid: userID) { (returnedName , returnedEmail) in
            self.userNameLabel.text = returnedName
            self.emailLabel.text = returnedEmail
            self.userNameLabel.reloadInputViews()
            self.emailLabel.reloadInputViews()
            
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.clipsToBounds = true
            
//            DispatchQueue.main.async {
//                DataService.instance.getImages(uid: userID, completion: {[weak self] (returnedImage) in
//                    guard let strongSelf = self else {return}
//                    strongSelf.profileImage.image = returnedImage
//                })
//            }
        }
        
    }
    
    
    
    
    @IBAction func logoutBtnWasPressed(_ sender: UIButton) {
        
        let altertViewController = UIAlertController(title: "Logout", message: "Are You Sure You Want Log Out", preferredStyle:.alert)
        let action1 = UIAlertAction(title: "Yes", style: .default) { (action) in
            
            do {
                try Auth.auth().signOut()
            } catch (let error) {
                print(error)
            }
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let authVC = storyboard.instantiateViewController(withIdentifier: "MainAuthVC")
            self.present(authVC, animated: true,completion: nil)
            
        }
        let action2 = UIAlertAction(title: "No", style: .default) { (action) in
            return
        }
        
        altertViewController.addAction(action1)
        altertViewController.addAction(action2)
        self.present(altertViewController, animated: true)
        
    }
    
    
    
    //
    //    func getImages2 (uid : String , myImage : UIImage ){
    //        let downloadImageRef = Storage.storage().reference().child(uid).child("Profile Picture")
    //
    //        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
    //            if let data = data {
    //                let image = UIImage(data: data)
    //
    //            }
    //            print(error ?? "NO ERROR")
    //        }
    //
    //        downloadtask.observe(.progress) { (snapshot) in
    //            print(snapshot.progress ?? "NO MORE PROGRESS")
    //        }
    //
    //        downloadtask.resume()
    //    }
    
    
}
