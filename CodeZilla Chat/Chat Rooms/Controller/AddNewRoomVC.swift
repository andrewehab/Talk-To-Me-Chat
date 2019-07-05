//
//  AddNewRoomVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 7/1/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class AddNewRoomVC: UIViewController {
    
    @IBOutlet weak var roomDescriptionTextView: PaddingTextField!
    @IBOutlet weak var roomNameTextField: PaddingTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController!.tabBar.isHidden = true
        self.navigationItem.title = "New Room"
        
    }
    
    @IBAction func addBtnWasPressed(_ sender: UIButton) {
        if roomNameTextField.text?.isEmpty == true || roomDescriptionTextView.text?.isEmpty == true
        {
            showAltertControllerWithAction(title: "Warning", message: "Chat Room Name Can't be Empty", altertStyle: .alert, actionTitle: "Okay", actionStyle: .default)
            return
        } else {
            DataService.instance.createRoom(roomName: roomNameTextField.text!, roomDesc: roomDescriptionTextView.text!)
            roomNameTextField.text? = ""
            roomDescriptionTextView.text? = ""
            self.navigationController?.popToRootViewController(animated: true)
            
        }
    }
}
