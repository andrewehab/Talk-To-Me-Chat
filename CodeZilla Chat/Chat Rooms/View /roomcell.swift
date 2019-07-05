//
//  roomcell.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/29/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class roomcell: UITableViewCell {

    @IBOutlet weak var containerView: GradientView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomDescription: UILabel!
    
    
    func updateViews(room : Room){
        roomName.text = room.roomName
        roomDescription.text = room.roomDesc
        
    }
}
