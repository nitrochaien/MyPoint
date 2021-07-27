//
//  ProfileHeaderView.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ProfileHeaderView: UICollectionReusableView {

    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankNameLabel: UILabel!
    @IBOutlet weak var showMoreRankButton: UIButton!
    @IBOutlet weak var pointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        profileView.addShadow(ofColor: .black,
                              radius: 8,
                              offset: .zero,
                              opacity: 0.3)
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToRanking))
        profileView.addGestureRecognizer(tap)
    }
    
    @objc private func goToRanking() {
        let storyboard = UIStoryboard(name: "MemberShipLevel", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MemberShipLevelViewController") as! MemberShipLevelViewController
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.navigationBar.isHidden = false
        tabbarViewController?.pushViewController(viewController, animated: true)
    }

    func updateData(unread: Int) {
        let storage = Storage.shared
        let userData = storage.loginData
        pointLabel.text = userData?.workingSite?.customerBalance?.simpleAmountDisplay
        profileNameLabel.text = userData?.workerSite?.usernameDisplay
        if let localImage = storage.localUserProfilePic {
            profileImageView.image = localImage
        } else {
            profileImageView.image = userData?.workerSite?.image
        }

        let memberShip = userData?.workingSite?.primaryMembership?.membershipLevel
        rankNameLabel.text = memberShip?.levelName
        rankNameLabel.textColor = UIColor(hexString: memberShip?.levelTextColor ?? "")
        rankImageView.setImage(withURL: memberShip?.levelLogo)
        // Initialization code
        
        if unread > 0 {
          notificationButton.setImage(UIImage(named: "Highlight 1"), for: .normal)
        } else {
          notificationButton.setImage(UIImage(named: "NoNotification"), for: .normal)
        }
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 0..<12:
            greetingLabel.text = "main.greeting_morning".localized
            //        case 11..<14:
        //            greetingLabel.text = "main.greeting_noon".localized
        case 12..<18:
            greetingLabel.text = "main.greeting_afternoon".localized
        case 18..<24:
            greetingLabel.text = "main.greeting_night".localized
            //        case 0..<5:
        //            greetingLabel.text = "main.greeting_night".localized
        default:
            greetingLabel.text = ""
        }
    }

    @IBAction private func didPressNotificationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotificationListViewController")
        controller.hidesBottomBarWhenPushed = true
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.navigationBar.isHidden = false
        tabbarViewController?.pushViewController(controller, animated: true)
    }
}
