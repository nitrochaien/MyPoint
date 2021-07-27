//
//  UIViewController+Root.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

extension UIViewController {
    func setRoot(storyboard: String, viewControllerId: String) {
        let vc = UIStoryboard(name: storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: viewControllerId)
        let navigation = UINavigationController(rootViewController: vc)
        if let appDelegate = UIApplication.shared.delegate {
            if let windowCheck = appDelegate.window {
                windowCheck!.rootViewController = navigation

                UIView.transition(with: windowCheck!,
                                  duration: 0.3,
                                  options: .transitionCrossDissolve,
                                  animations: nil,
                                  completion: nil)
            }
        }
    }

    func showCustomAlert(withTitle title: String, andContent content: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Create custom content viewController
        let contentViewController = CustomAlertViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        contentViewController.updateData(withTitle: title, andContent: content)
        contentViewController.onDismiss = {
            completion?()
        }
        present(alertController, animated: true, completion: nil)
    }

    func showTwoButtonsAlert(with model: TwoOptionsButtonModel,
                             leftButtonCompletion: (() -> Void)? = nil,
                             rightButtonCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Create custom content viewController
        let contentViewController = TwoOptionsAlertViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        contentViewController.updateData(with: model)
        contentViewController.handlePressRightButton = {
            rightButtonCompletion?()
        }
        contentViewController.handlePressLeftButton = {
            leftButtonCompletion?()
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func showTwoButtonsAlert(information: NSMutableAttributedString, with model: TwoOptionsButtonModel,
                             leftButtonCompletion: (() -> Void)? = nil,
                             rightButtonCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Create custom content viewController
        let contentViewController = TwoOptionsAlertViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        contentViewController.updateData(information: information, with: model)
        contentViewController.handlePressRightButton = {
            rightButtonCompletion?()
        }
        contentViewController.handlePressLeftButton = {
            leftButtonCompletion?()
        }
        present(alertController, animated: true, completion: nil)
    }

    func showTwoButtonsAlertWithImage(information: NSMutableAttributedString, with model: TwoOptionsButtonWithImage,
                                      topButtonCompletion: (() -> Void)? = nil,
                                      bottomButtonCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        // Create custom content viewController
        let contentViewController = TwoOptionsAlertWithImageViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        contentViewController.updateData(information: information, with: model)
        contentViewController.handlePressTopButton = {
            topButtonCompletion?()
        }
        contentViewController.handlePressBottomButton = {
            bottomButtonCompletion?()
        }
        present(alertController, animated: true, completion: nil)
    }

    func showChangeCardSuccess(dueDate: String,
                               code: String,
                               _ completion: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = ChangeCardRedeemPopUpViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        contentViewController.setData(dueDate, code: code)
        contentViewController.didSelectProceed = {
            completion()
        }
        present(alertController, animated: true, completion: nil)
    }

    func showChangePackageSuccess() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = ChangePackageSuccessPopUpViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }

    func showRequireInfoPopUp(_ completion: @escaping (() -> Void)) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = RequireInfoPopUpViewController()
        contentViewController.didConfirm = {
            completion()
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }

    func showCashbackTutorial() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let width = NSLayoutConstraint(item: alertController.view!,
                                       attribute: .width,
                                       relatedBy: .equal,
                                       toItem: nil,
                                       attribute: .notAnAttribute,
                                       multiplier: 1,
                                       constant: UIScreen.main.bounds.width * 4/5)
        alertController.view.addConstraint(width)
        let contentViewController = CashbackTutorialViewController()
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
    
    func popToViewController(type ViewController: UIViewController.Type) {
        guard let navigation = navigationController else { return }

        for controller in navigation.viewControllers as Array {
            if controller.isKind(of: ViewController.self) {
                navigation.popToViewController(controller, animated: true)
            }
        }
    }

    func customizeBackButton() {
        let backBtn = UIBarButtonItem(image: UIImage(named: "ic_back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        backBtn.tintColor = UIColor(hexString: "#032041")
        navigationItem.leftBarButtonItem = backBtn
    }

    func pushFromBottom(_ vc: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .moveIn
        transition.subtype = .fromTop
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(vc, animated: false)
    }

    func popFromTop() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromBottom
        navigationController?.view.layer.add(transition, forKey: nil)
        _ = navigationController?.popViewController(animated: false)
    }

    func popFromTop(to vc: UIViewController.Type) {
        guard let navigation = navigationController else { return }

        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .reveal
        transition.subtype = .fromBottom
        navigation.view.layer.add(transition, forKey: nil)

        for controller in navigation.viewControllers as Array {
            if controller.isKind(of: vc.self) {
                navigation.popToViewController(controller, animated: true)
                return
            }
        }
        navigationController?.popViewController(animated: true)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func showCardDetail(with id: ProductId,
                        delegate: CardDetailViewControllerDelegate? = nil) {
        let vc = CardDetailViewController()
        vc.setValue(id)
        vc.delegate = delegate
        navigationController?.pushViewController(vc, animated: true)
    }

    func showVoucherDetail(with id: String, readyToUse: Bool, isUsable: Bool) {
        let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
        if let viewController = storyboard
            .instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController {
            viewController.voucherId = id
            viewController.readyToUse = readyToUse
            viewController.isUsable = isUsable
            navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func showGoogleMap(withLat lat: Double, long: Double) {
        if let appURL = URL(string: "comgooglemaps://"), UIApplication.shared.canOpenURL(appURL) {
            let path = "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(long)&directionsmode=driving"
            if let url = URL(string: path) {
                UIApplication.shared.open(url, options: [:])
            }
        } else {
            let browser = "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=driving"
            if let urlDestination = URL(string: browser) {
                UIApplication.shared.open(urlDestination)
            }
        }
    }

    func updateBalance(isShowLoadding: Bool = true, _ completion: (() -> Void)?) {
        NotificationServices().getList(isShowLoadding: isShowLoadding) { (response, success) in
            if success {
                if let response = response as? NotificationListResponse {
                    Storage.shared
                        .loginData?
                        .workingSite?
                        .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                    completion?()
                }
            }
        }
    }
}
