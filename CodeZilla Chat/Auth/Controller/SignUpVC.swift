//
//  SignUpVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/8/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var firstNameTextField: PaddingTextField!
    @IBOutlet weak var firstNameErrorMsg: UILabel!
    
    
    @IBOutlet weak var lastNameTextField: PaddingTextField!
    @IBOutlet weak var lastNameErrorMsg: UILabel!
    
    @IBOutlet weak var emailTextField: PaddingTextField!
    @IBOutlet weak var emailErrorMsg: UILabel!
    
    @IBOutlet weak var passwordTextField: PaddingTextField!
    @IBOutlet weak var passwordErrorMsg: UILabel!
    
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTextField.addTarget(self, action: #selector(CheckForVEmailalidation), for: .editingDidEnd)
        passwordTextField.addTarget(self, action: #selector(CheckForPasswordValidation), for: .editingDidEnd)
        firstNameTextField.addTarget(self, action: #selector(CheckForFirstNameValidation), for: .editingDidEnd)
        lastNameTextField.addTarget(self, action: #selector(CheckForLaseNameValidation), for: .editingDidEnd)
        
        
        signupBtn.makeRoundedButton(cornerRadius: 20)
        emailTextField.makeRoundedText(cornerRadius: 20)
        passwordTextField.makeRoundedText(cornerRadius: 20)
        firstNameTextField.makeRoundedText(cornerRadius: 20)
        lastNameTextField.makeRoundedText(cornerRadius: 20)
        
    }
    
    @objc func CheckForVEmailalidation(){
        if (emailTextField.text?.isValid(validityType: .email)) == false {
            emailErrorMsg.text = "   Invalid Email"
            emailErrorMsg.isHidden = false
            emailTextField.setIcon(#imageLiteral(resourceName: "error2"))
//            signupBtn.isEnabled = false
        } else {
            emailErrorMsg.isHidden = true
            emailTextField.setIcon(#imageLiteral(resourceName: "truemark"))
        }
    }
    
    @objc func CheckForPasswordValidation(){
        if (passwordTextField.text?.isValid(validityType: .password)) == false {
            passwordErrorMsg.text = "   Password Must Contains at Least 1 Upper Case,Lower Case and Numeric"
            passwordErrorMsg.isHidden = false
            passwordTextField.setIcon(#imageLiteral(resourceName: "error2"))
//            signupBtn.isEnabled = false
        } else {
            passwordTextField.setIcon(#imageLiteral(resourceName: "truemark"))
            passwordErrorMsg.isHidden = true
        }
    }
    
    @objc func CheckForFirstNameValidation(){
        if (firstNameTextField.text?.isValid(validityType: .username)) == false {
            firstNameErrorMsg.text = "   Invalid Name"
            firstNameErrorMsg.isHidden = false
            firstNameTextField.setIcon(#imageLiteral(resourceName: "error2"))
//            signupBtn.isEnabled = false
        } else {
            firstNameErrorMsg.isHidden = true
            firstNameTextField.setIcon(#imageLiteral(resourceName: "truemark"))
        }
    }
    
    @objc func CheckForLaseNameValidation(){
        if (firstNameTextField.text?.isValid(validityType: .username)) == false {
            lastNameErrorMsg.text = "   Invalid Name"
            lastNameErrorMsg.isHidden = false
            lastNameTextField.setIcon(#imageLiteral(resourceName: "error2"))
//            signupBtn.isEnabled = false
        } else {
            lastNameErrorMsg.isHidden = true
            lastNameTextField.setIcon(#imageLiteral(resourceName: "truemark"))
        }
    }
    
    @IBAction func signupBtnWasPressed(_ sender: UIButton) {
        showSpinner(onView: view)
        if emailTextField.text != nil && passwordTextField.text != nil && firstNameTextField.text != nil && lastNameTextField.text != nil {
//            self.signupBtn.isEnabled = false
            AuthService.instance.registerForNewUser(withEmail: emailTextField.text!, andPassword: passwordTextField.text!, andFirstName: firstNameTextField.text!, andLastName: lastNameTextField.text!) { (success, error) in
                
                if success {
                    self.removeSpinner()
//                    self.signupBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
//                    self.signupBtn.isEnabled = true
                }
            }
        }
    }
    
    
    @IBAction func closeBtnWasPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
