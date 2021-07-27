//
//  UIApplication.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        
        return topViewController
    }
    
}
