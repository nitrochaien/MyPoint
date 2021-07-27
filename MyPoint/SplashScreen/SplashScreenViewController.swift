//
//  SplashScreenViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/10/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    private let presenter = SplashScreenPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        indicatorView.startAnimating()
        presenter.delegate = self

        if Storage.shared.deviceToken == nil {
            //            NotificationCenter.default.addObserver(self,
            //                                                   selector: #selector(handleDeviceToken),
            //                                                   name: NotificationName.didGetDeviceToken,
            //                                                   object: nil)
            Storage.shared.deviceToken = UUID().uuidString
        }
        handleAppState()
    }

    @objc private func handleDeviceToken() {
        handleAppState()
    }

    private func handleAppState() {
        if Storage.shared.isFirstTimeUseApp {
            Storage.shared.isFirstTimeUseApp = false
            setRoot(storyboard: "Onboarding", viewControllerId: "OnboardingViewController")
        } else {
            if Storage.shared.deviceToken != nil {
                presenter.requestCheckingLoginState()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension SplashScreenViewController: SplashScreenDelegate {
    func handleDidNotEnterNickname() {
        guard let vc = UIStoryboard(name: "Authenciation",
                                    bundle: nil)
            .instantiateViewController(withIdentifier: "CreateNicknameViewController") as? CreateNicknameViewController else { return }
        let navigation = UINavigationController(rootViewController: vc)
        if let appDelegate = UIApplication.shared.delegate {
            if let windowCheck = appDelegate.window {
                windowCheck!.rootViewController = navigation
            }
        }
    }

    func showLoginScreen() {
        setRoot(storyboard: "Authenciation", viewControllerId: "LoginViewController")
    }

    func requestSuccess() {
        setRoot(storyboard: "Tabbar", viewControllerId: "TabbarViewController")
    }
}
