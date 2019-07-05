//
//  Spinner.swift
//  Music Player
//
//  Created by AnDy on 5/9/19.
//  Copyright © 2019 AnDy. All rights reserved.
//

import Foundation
import UIKit

var vSpinner : UIView?

extension UIViewController {
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicaror = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicaror.startAnimating()
        activityIndicaror.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(activityIndicaror)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
}
