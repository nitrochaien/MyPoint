//
//  PushNotificationManager.swift
//  MyPoint
//
//  Created by Nam Vu on 4/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

var pushUserInfo: [AnyHashable: Any]?

class PushNotificationManager {
    static let shared = PushNotificationManager()

    func handlePushNotification() {
        if let userInfo = pushUserInfo {
            if let topViewController = UIApplication.topViewController() {
                if Storage.shared.loginData == nil {
                    topViewController.setRoot(storyboard: "Authenciation",
                                              viewControllerId: "LoginViewController")
                    pushUserInfo = nil
                    return
                }

                if topViewController is SplashScreenViewController {
                    return
                }

                if let clickAction = userInfo["click_action_type"] as? String,
                    let param = userInfo["click_action_param"] as? String {
                    if clickAction.trimmed == ClickActionType.none.rawValue {
                        if let title = userInfo["title"] as? String,
                            let body = userInfo["body"] as? String {
                            ClickActionType.showNotificationDetail(with: title,
                                                                   and: body,
                                                                   from: topViewController.navigationController)
                        }
                    } else {
                        ClickActionType
                            .showViewController(withType: clickAction,
                                                andParam: param,
                                                from: topViewController.navigationController)
                    }
                    pushUserInfo = nil
                }
            }
        }
    }
}

extension UIApplication {
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        return viewController
    }
}
