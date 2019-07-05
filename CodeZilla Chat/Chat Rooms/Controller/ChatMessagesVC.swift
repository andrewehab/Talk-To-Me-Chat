//
//  ChatMessagesVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/12/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit
import Firebase

class ChatMessagesVC: UIViewController {
    
    // the passed data from ChatRoomVC
    var roomData : Room?
    var messagesData : [Message]?
    var nameSender : String?
    var messages : [String]?
    
    @IBOutlet weak var messageLbl: PaddingTextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageTabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the tab bar
        self.tabBarController!.tabBar.isHidden = true
        
        // remove the back buttom title
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // make the send button circular
        self.sendBtn.layer.cornerRadius = self.sendBtn.frame.size.width / 2
        self.sendBtn.clipsToBounds = true
        
        // set name to the navigation item with room name
        self.navigationItem.title = roomData?.roomName
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        // make rounded text with border color
        self.messageLbl.layer.cornerRadius = 20
        self.messageLbl.clipsToBounds = true
        self.messageLbl.layer.borderWidth = 2.0
        self.messageLbl.layer.borderColor = #colorLiteral(red: 0.6039215686, green: 0.4, blue: 0.8274509804, alpha: 1)
        
        
        messageTabelView.dataSource = self
        messageTabelView.delegate = self
        getMessageData()
        
    }
    
    
    
    func getMessageData(){
        guard let roomID = roomData?.roomID else {return}
        DataService.instance.getMessagesData(roomId: roomID) { (returnedMessagesData) in
            self.messagesData =  returnedMessagesData
            self.messageTabelView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let currentUser = Auth.auth().currentUser?.uid else {return}
        DataService.instance.getUserName(uid: currentUser) { (returnedName , returnedEmail) in
            self.nameSender = returnedName
        }
        
    }
    
    @IBAction func sendBtnWasPressed(_ sender: UIButton) {
        guard let messageContent = messageLbl.text , messageLbl.text?.isEmpty == false , let roomID = roomData?.roomID else {
            return}
        
        DataService.instance.createMessage(roomID: roomID, senderName:  nameSender ?? "", messageContent: messageContent)
        messageLbl.text = ""
    }
    
    
}



extension ChatMessagesVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? messageCell else {return UITableViewCell() }
        let messages = messagesData![indexPath.row]
        cell.updateViews(message: messages)
        
        if messagesData![indexPath.row].senderId == Auth.auth().currentUser?.uid {
            cell.checkSenderType(type: .me)
        } else {
            cell.checkSenderType(type: .other)
        }
        
        return cell
    }
    
}



