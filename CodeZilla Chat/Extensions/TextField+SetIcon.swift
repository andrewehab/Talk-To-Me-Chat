//
//  TextField+SetIcon.swift
//  CodeZilla Chat
//
//  Created by AnDy on 6/9/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: -5, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 20, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        rightView = iconContainerView
        rightViewMode = .always

    }
    
    func makeRoundedText ( cornerRadius : CGFloat){
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
}
