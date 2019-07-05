//
//  feedCell.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/30/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class feedCell: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var feedText: UILabel!
    @IBOutlet var profileImage: UIImageView!
    
    func updateViews(feeds : Feeds){
        feedText.text = feeds.postContent
        let senderID = feeds.senderID
        DataService.instance.getUserName(uid: senderID!) { (userName , email)  in
            self.senderName.text = userName
        }
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
//        DispatchQueue.main.async {
//            DataService.instance.getImages(uid: senderID!) { [weak self](returnedImage) in
//                guard let strongSelf = self else {return}
//                strongSelf.profileImage.image = returnedImage
//
//            }
//        }
//        self.profileImage.image = DataService.instance.getImages3(uid: senderID!)
    }
    
}
