//
//  GradientView.swift
//  Music App
//
//  Created by AnDy on 5/2/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import UIKit
@IBDesignable

class GradientViewWithCornerRadius: UIView {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    @IBInspectable var topColor: UIColor = #colorLiteral(red: 0.2823529412, green: 0, blue: 0.368627451, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = #colorLiteral(red: 0.2470588235, green: 0.09803921569, blue: 0.1607843137, alpha: 1) {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}


