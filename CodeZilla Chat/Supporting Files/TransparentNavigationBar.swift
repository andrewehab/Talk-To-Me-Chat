//
//  TransparentNavigationBar.swift
//  My Music
//
//  Created by AnDy on 5/5/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit

class TransparentNavigationBar: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
}
