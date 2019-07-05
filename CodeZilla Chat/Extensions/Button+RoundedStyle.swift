//
//  Button+RoundedStyle.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/28/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

extension UIButton{
    
    func makeRoundedButton ( cornerRadius : CGFloat){
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}


