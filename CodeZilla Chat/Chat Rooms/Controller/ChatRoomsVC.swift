//
//  ChatRoomsVC.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/11/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit
import Firebase

class ChatRoomsVC: UIViewController {
    
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    @IBOutlet weak var roomNameTextField: PaddingTextField!
    
    var RoomData = [Room]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // change the navigation bar title and color
        self.navigationItem.title = "Chat Rooms"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        chatRoomTableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            DataService.instance.getRoomData { (returnedRoomdData) in
                self.RoomData = returnedRoomdData
                self.chatRoomTableView.reloadData()
            }
        }
        
        //show the tab bar
        self.tabBarController!.tabBar.isHidden = false
        
    }
    
    
}


extension ChatRoomsVC : UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell", for: indexPath) as? roomcell else {return UITableViewCell()}
        
        let myRoom = RoomData[indexPath.row]
        cell.updateViews(room: myRoom)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.contentView.backgroundColor = UIColor.lightGray
        let chatMessageVC = storyboard?.instantiateViewController(withIdentifier: "ChatMessagesVC") as! ChatMessagesVC
        chatMessageVC.roomData = RoomData[indexPath.row]
        self.navigationController?.pushViewController(chatMessageVC , animated: true)
    }
    
    
    
    // delete room
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DataService.instance.removeRooms(roomID: RoomData[indexPath.row].roomID!)
            RoomData.remove(at: indexPath.row)
            chatRoomTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    // change the color of delete select
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            tableView.dataSource?.tableView!(tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        deleteButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        return [deleteButton]
    }
    
} 
