//
//  WriteFeedVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/30/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class CreateFeedVC: UIViewController {
    
    
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messageText.layer.cornerRadius = 20
        self.messageText.clipsToBounds = true
        self.messageText.layer.borderWidth = 1.0
        self.messageText.layer.borderColor = #colorLiteral(red: 0.6039215686, green: 0.4, blue: 0.8274509804, alpha: 1)
        
        self.sendBtn.layer.cornerRadius = 20
        self.sendBtn.clipsToBounds = true
        
        self.messageText.delegate = self
        
    }
    
    
    @IBAction func sendBtnWasPressed(_ sender: UIButton) {
        
        if messageText.text != nil && messageText.text != "Say Something here ..."{
            DataService.instance.createFeed(content: messageText.text) { (success, error) in
                
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.showAltertControllerWithAction(title: "Sorry", message: "Something Went Wrong...!", altertStyle: .alert, actionTitle: "Okay", actionStyle: .default)
                }
            }
        }
        
    }
    
    
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
 
}


extension CreateFeedVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = " "
    }
}
