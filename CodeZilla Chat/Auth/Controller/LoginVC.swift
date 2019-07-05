//
//  LoginVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/8/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var emailErrorMsg: UILabel!
    
    @IBOutlet weak var passwordTextField: PaddingTextField!
    @IBOutlet weak var passwordErrorMsg: UILabel!
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.addTarget(self, action: #selector(CheckVEmailIsEmpty), for: .editingDidEnd)
        
        passwordTextField.addTarget(self, action: #selector(CheckVPasswordIsEmpty), for: .editingDidEnd)
        
        loginBtn.makeRoundedButton(cornerRadius: 20)
        emailTextField.makeRoundedText(cornerRadius: 20)
        passwordTextField.makeRoundedText(cornerRadius: 20)
        
    }
    
    @objc func CheckVEmailIsEmpty(){
        if emailTextField.text!.isEmpty {
            emailErrorMsg.text = "   Empty Email"
            emailErrorMsg.isHidden = false
            emailTextField.setIcon(#imageLiteral(resourceName: "error2"))
            loginBtn.isEnabled = false
        } else {
            loginBtn.isEnabled = true
            emailErrorMsg.isHidden = true
            emailTextField.setIcon(UIImage())
        }
    }
    
    @objc func CheckVPasswordIsEmpty(){
        if passwordTextField.text!.isEmpty {
            passwordErrorMsg.text = "   Empty Password"
            passwordErrorMsg.isHidden = false
            passwordTextField.setIcon(#imageLiteral(resourceName: "error2"))
            loginBtn.isEnabled = false
        } else {
            loginBtn.isEnabled = true
            passwordErrorMsg.isHidden = true
            passwordTextField.setIcon(UIImage())
            
        }
    }
    @IBAction func loginBtnWasPressed(_ sender: UIButton) {
        showSpinner(onView: view)
        if emailTextField.text != nil && passwordTextField.text != nil  {
            AuthService.instance.loginForCurrentUser(withEmail: emailTextField.text! , andPassword: passwordTextField.text!) { (success, error) in
                self.loginBtn.isEnabled = false
                
                if success{
                    self.removeSpinner()
                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
                    let chatRoomVC = storyboard.instantiateViewController(withIdentifier: "TabBarVC")
                    self.present(chatRoomVC,animated: true,completion: nil)
                    self.loginBtn.isEnabled = true
                    
                } else {
                    self.removeSpinner()
                    self.loginBtn.isEnabled = true
                    self.showAltertControllerWithAction(title: "Warning", message: "Invalid Email Or Password", altertStyle: .alert, actionTitle: "Dismiss", actionStyle: .default)
                    return
                }
            }
        }
    }
    
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
