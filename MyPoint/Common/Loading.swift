//
//  Loading.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import Whisper

final class Loading {
    static func startAnimation(messageContent: String = "") {
        let activityData = ActivityData(size: .init(width: 24, height: 24),
                                        message: messageContent,
                                        type: NVActivityIndicatorType.lineSpinFadeLoader,
                                        color: UIColor.red,
                                        backgroundColor: UIColor.clear, textColor: UIColor.black)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData, nil)
    }

    static func stopAnimation() {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
    }

    static func whisper(title: String = Bundle.main.displayName ?? "", subtitle: String = "") {
        let announcement = Announcement(title: title, subtitle: subtitle, image: UIImage(named: "alter"))
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            Whisper.show(shout: announcement, to: vc) {
                print("The shout was silent.")
            }
        } else if let navi = UIApplication.shared.keyWindow?.rootViewController?.navigationController {
            Whisper.show(shout: announcement, to: navi, completion: {
                print("The shout was silent.")
            })
        }
    }

    static var isLoading: Bool {
        return NVActivityIndicatorPresenter.sharedInstance.isAnimating
    }
}

extension Bundle {
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}
