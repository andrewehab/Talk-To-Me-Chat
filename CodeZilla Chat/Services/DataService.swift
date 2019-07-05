//
//  DataService.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/8/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit

let refrence = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    var userRefrense = refrence.child("users")
    var roomRefrence = refrence.child("room")
    var feedRefrence = refrence.child("feeds")
    
    var storage = Storage.storage()
    
    
    // Get a reference to the storage service using the default Firebase App
    let storageRef = Storage.storage().reference()
    
    //MARK:- CREATE USER BRANCH IN DATABASE
    func createUser(uid : String , userData : [String : Any]){
        userRefrense.child(uid).updateChildValues(userData)
    }
    
    //MARK:- GET THE NAME OF USER
    func getUserName(uid : String , handler : @escaping(_ name : String , _ emaail : String)->Void) {
        userRefrense.observe(.value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot]
                else { return }
            for users in userSnapShot {
                if users.key ==  uid {
                    let firstName = users.childSnapshot(forPath: "First Name") .value as! String
                    let lasttName = users.childSnapshot(forPath: "Last Name") .value as! String
                    let fullName = firstName + " " + lasttName
                    let email = users.childSnapshot(forPath: "Email") .value as! String
                    handler(fullName,email)
                }
            }
        }
    }
    
    
    
    
    
    
    
    //MARK:- CREATE ROOM BRANCH IN DATABASE
    func createRoom(roomName : String , roomDesc : String){
        let roomID = roomRefrence.childByAutoId().key!
        
        let roomData = ["Room Name" : roomName ,
                        "Room Description" : roomDesc]
        
        roomRefrence.child(roomID).updateChildValues(roomData)
        
    }
    
    
    //MARK:- CREATE MESSAGE BRANCH TO ROOM BRANCGIN DATABASE
    func createMessage(roomID : String , senderName : String , messageContent : String ){
        
        let messageData = ["Sender Name" : senderName ,
                           "Message Content" : messageContent ,
                           "Sender ID" : Auth.auth().currentUser?.uid]
        
        roomRefrence.observeSingleEvent(of: .value) { (messageSnapShot) in
            guard let messageSnapShot = messageSnapShot.children.allObjects as? [DataSnapshot]
                else {return}
            for message in messageSnapShot {
                if message.key == roomID {
                    self.roomRefrence.child(roomID).child("Messages").childByAutoId().updateChildValues(messageData)
                }
            }
        }
    }
    
    
    //MARK:- GET FEEDS FROM DATABASE
    func getRoomData(roomDataCompleted : @escaping(_ returnedRoomData : [Room])->Void){
        roomRefrence.observe(.value) { (roomSnapShot) in
            
            var arrayOfRoomsData = [Room]()
            
            guard let roomSnapShot = roomSnapShot.children.allObjects as? [DataSnapshot]
                else {return}
            
            for room in roomSnapShot {
                let roomName = room.childSnapshot(forPath: "Room Name").value as! String
                let roomID = room.key
                let roomDesc = room.childSnapshot(forPath: "Room Description").value as! String
                let roomData = Room(roomName: roomName, roomID: roomID, roomDesc: roomDesc)
                arrayOfRoomsData.append(roomData)
                roomDataCompleted(arrayOfRoomsData)
            }
        }
    }
    
    
    //MARK:- GET MESSAGES FROM DATABASE
    func getMessagesData(roomId : String , messagesDataReturned : @escaping(_ messagesData : [Message]) -> Void){
        
        var messagesData = [Message]()
        
        roomRefrence.child(roomId).child("Messages").observe(.childAdded) { (messageSnapShots) in
            guard let messageSnapShots = messageSnapShots.value as? [String : Any] else { return }
            let senderName = messageSnapShots["Sender Name"] as! String
            let senderId = messageSnapShots["Sender ID"] as! String
            let messageContent = messageSnapShots["Message Content"] as! String
            
            let allData = Message(senderName: senderName, senderId: senderId, messageContent: messageContent)
            messagesData.append(allData)
            messagesDataReturned(messagesData)
            
        }
    }
    //MARK:- REMOVE ROOM FROM DATABASE
    func removeRooms(roomID : String){
        roomRefrence.child(roomID).removeValue()
    }
    
    
    
    
    
    
    
    //MARK:- CREATE FEED BRANCH IN DATABASE
    func createFeed(content : String  , uploadCompleted : @escaping(_ success : Bool , _ error : Error?)->Void){
        let feedData = ["Content" : content ,
                        "Sender Id" : Auth.auth().currentUser?.uid ]
        feedRefrence.childByAutoId().updateChildValues(feedData)
        uploadCompleted(true,nil)
    }
    
    
    //MARK:- GET FEEDS FROM DATABASE
    func getFeedsData(returnedPostsCompleted : @escaping(_ success : Bool , _ error : Error? ,_ messagegs: [Feeds]?)->Void){
        var myImage : UIImage?
        feedRefrence.observe(.value) { (feedMessageSnapShot) in
            var feedsArray = [Feeds]()
            guard let feedMessageSnapShot = feedMessageSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for message in feedMessageSnapShot {
                let content = message.childSnapshot(forPath: "Content").value as! String
                let sendeId = message.childSnapshot(forPath: "Sender Id").value as! String
                //                self.getImages2(uid: sendeId, completion: { (returnedImage) in
                //                    myImage = returnedImage
                //                })
                let message = Feeds(postContent: content, senderID: sendeId, senderImage: myImage)
                feedsArray.append(message)
                
                returnedPostsCompleted(true,nil,feedsArray)
            }
        }
    }
    
    
    
    
    func uploadProfilePic(){
        
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "picture.width(480).height(480)"])
        graphRequest?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print("Error",error!.localizedDescription)
            }
            else{
                print(result!)
                let field = result! as? [String:Any]
                if let imageURL = ((field!["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                    print(imageURL)
                    let url = URL(string: imageURL)
                    let fileData = NSData(contentsOf: url!)
                    
                    let storageRef = self.storage.reference().child(Auth.auth().currentUser!.uid).child("Profile Picture")
                    storageRef.putData(fileData! as Data).observe(.success) {
                        (snapshot) in
                        // When the image has successfully uploaded, we get it's download URL
                        // Write the download URL to the Realtime Database
                        storageRef.downloadURL(completion: { (url, error) in
                            
                            guard let url = url?.absoluteString else {return}
                            self.userRefrense.child(Auth.auth().currentUser!.uid).updateChildValues(["Profile Picture URL" : url])
                        })
                    }
                }
            }
        })
    }
    
    
    func getImages(uid : String , completion : @escaping(_ returnedImage : UIImage)->Void){
        let downloadImageRef = self.storage.reference().child(uid).child("Profile Picture")
        
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            guard let data = data else {return}
            let image = UIImage(data: data)
            completion(image ?? UIImage())
            
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
    }
    
    
    
    func getImages3(uid : String ) -> UIImage {
        let downloadImageRef = self.storage.reference().child(uid).child("Profile Picture")
        var myImage : UIImage?
        let downloadtask = downloadImageRef.getData(maxSize: 1024 * 1024 * 12) { (data, error) in
            guard let data = data else {return}
            let image = UIImage(data: data)
            myImage = image
            print(error ?? "NO ERROR")
        }
        
        downloadtask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
        }
        
        downloadtask.resume()
        return myImage ?? UIImage()
    }
    
    
    
    //
    //    func getImages2 (uid : String , completion : @escaping(_ returnedImage : UIImage)->Void){
    //        var myUrl : URL?
    //        userRefrense.observe(.value) { (userSnapShot) in
    //            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot]
    //                else { return }
    //            for users in userSnapShot {
    //                if users.key ==  uid {
    //                    myUrl  = users.childSnapshot(forPath: "Profile Picture URL") .value as! URL
    //                    URLSession.shared.dataTask(with: myUrl!, completionHandler: { (data, response, err) in
    //                        if let err = err {
    //                            print("Error downloading URL, \(err.localizedDescription)")
    //                            return
    //                        }
    //
    //                        guard let data = data else { return }
    //                        let image = UIImage(data: data) // Now image stores the image that you download
    //                        completion(image!)
    //                    })
    //                }
    //            }
    //        }
    //    }
    
}
