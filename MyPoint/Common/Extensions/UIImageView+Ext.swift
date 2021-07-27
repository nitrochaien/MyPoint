//
//  UIImageView+Ext.swift
//  MyPoint
//
//  Created by Nam Vu on 1/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(withURL urlString: String?,
                  placeholderImage: String = "alter") {
        guard let urlString = urlString else { return }
        guard let validString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        sd_setImage(with: URL(string: validString),
                         placeholderImage: UIImage(named: placeholderImage),
                         options: [.progressiveLoad, .refreshCached],
                         progress: { (_, _, _) in
        }) { (_, _, _, _) in
        }
    }
}
