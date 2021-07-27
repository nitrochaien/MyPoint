//
//  MemberShipLevelViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/6/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Kingfisher

final class MemberShipLevelViewController: BaseViewController {

    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var totalPointHeaderLabel: UILabel!
    @IBOutlet weak var levelLogoImageView: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var currentPointLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var currentPointTrackingLabel: UILabel!
    @IBOutlet weak var totalPointTrackingLabel: UILabel!
    @IBOutlet weak var nextRankLabel: UILabel!
    @IBOutlet weak var rankingHeaderLabel: UILabel!
    @IBOutlet weak var rankingPrivilegeView: UIView!
    @IBOutlet weak var rankingPrivilegeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextRankPointLabel: UILabel!
    @IBOutlet weak var nextRankHeaderLabel: UILabel!
    @IBOutlet weak var lbTitlePointWillExprie: UILabel!
    @IBOutlet weak var lbValuePointWillExprie: UILabel!
    
    @IBOutlet weak var heightConstraintViewExprie: NSLayoutConstraint!
    private let presenter = MembershipPrivilegePresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        presenter.delegate = self
        customizeBackButton()
        customizeRightBarButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getListMembershipPrivilege()
            presenter.getCustomerBalanceGetDetail()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        //      navigationController?.navigationBar.isHidden = true
    }
    func showPointExprieToView(listAllCurrencyPools: [AllCurrencyPools]) {
        let balanceDetail = listAllCurrencyPools[0].balanceDetails
        var itemSelected: BalanceDetails?
      //  balanceDetail[0].expiredDate = "2021-03-10 14:30:44"
        for item in balanceDetail where  item.expiredDate != nil {
            itemSelected = item
            break
        }
        guard itemSelected != nil else {
            heightConstraintViewExprie.constant = 0
            return
        }
        let pointNeeded =  Double(itemSelected?.point ?? "0")
        lbTitlePointWillExprie.text = "personal.point_will_exprie".localized
        self.lbValuePointWillExprie.attributedText =
            self.addAttributedTextPointWillExprie(point: pointNeeded!.formattedWithSeparator,
                                                  date: itemSelected?.expiredDate?.dateToString(
                                                    fromFormat: "yyyy-MM-dd HH:mm:ss", "dd.MM.yyyy") ?? "")
        heightConstraintViewExprie.constant = 80
    }
    func initView(listLevels: [Level]) {
        self.title = "personal.membershipLevel".localized
        progressBar.progressTintColor = UIColor(hexString: "#F15757")
        progressBar.trackTintColor = UIColor(hexString: "#FFBCC0")
        totalPointHeaderLabel.text = "personal.total_point".localized
        rankingHeaderLabel.text = "personal.rank_user".localized
        let storyboard = UIStoryboard(name: "MembershipPrivilege", bundle: nil)
        let viewController = storyboard
            .instantiateViewController(withIdentifier: "MembershipPrivilegeViewController") as? MembershipPrivilegeViewController
        viewController?.listLevel = listLevels
        viewController?.delegate = self
        let tab = MembershipPrivilegeTabViewController()
        tab.navigationController?.navigationBar.isHidden = true
        var rankingTabs = [RankingTab]()
        for level in listLevels {
            if let url = URL(string: level.logo ?? ""), let imageData = NSData(contentsOf: url) {
                rankingTabs.append(RankingTab(title: level.membershipLevelName ?? "",
                                              image: UIImage(data: imageData as Data) ?? UIImage(), viewController: viewController!))
            } else {
                rankingTabs.append(RankingTab(title: level.membershipLevelName ?? "", image: UIImage(), viewController: viewController!))
            }
        }
        tab.setTitles(rankingTabs: rankingTabs, distribution: .segmented, swipeToScroll: false)

        profileBackgroundImageView.addShadow(ofColor: UIColor(red: 55/255,
                                                              green: 103/255,
                                                              blue: 160/255,
                                                              alpha: 0.1),
                                             radius: 20,
                                             offset: CGSize(width: 6, height: 20),
                                             opacity: 0.1)
        
        rankingPrivilegeView.addShadow(ofColor: .lightGray,
                                       radius: 8,
                                       offset: .zero,
                                       opacity: 0.5)

        rankingPrivilegeView.addSubview(tab.view)
        tab.view.cornerRadius = 8
        tab.view.clipsToBounds = true
        tab.view.makeConstraintToFullWithParentView()
        addChild(tab)
        tab.didMove(toParent: self)
    }
    
    func display(currentLevel: Level, index: Int) {
        DispatchQueue.main.async {
//            let userData = Storage.shared.loginData
            if let url = URL(string: currentLevel.images?.first?.imageURL ?? "") {
                self.profileBackgroundImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.profileBackgroundImageView.image = UIImage(named: "alter")
            }
            
            if let url = URL(string: currentLevel.logo ?? "") {
                self.levelLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.levelLogoImageView.image = UIImage(named: "alter")
            }
            
            self.levelLabel.text = currentLevel.membershipLevelName
            let nextPoint = Int(Float(currentLevel.upgradeWhenCounterIsGreaterOrEqual ?? "0.0") ?? 0.0)
            let currentPoint = Int(Float(currentLevel.accumulatedCounter?.counterValue ?? "0") ?? 0)
            //
            //                self.currentPointLabel.text = String(format: "personal.you_have".localized, currentPoint)
//          self.currentPointLabel.text = String(format: "personal.you_have".localized,
//                                               userData?.workingSite?.customerBalance?.amountActiveDisplay ?? "")
            self.currentPointLabel.text = String(format: "personal.you_have".localized, (currentLevel.accumulatedCounter?.counterValueDisplay ?? ""))
            self.currentPointTrackingLabel.text = (currentLevel.accumulatedCounter?.counterValueDisplay ?? "") + "/"
            self.totalPointTrackingLabel.text = currentLevel.upgradeWhenCounterIsGreaterOrEqualDisplay
            let pointNeeded =  Double(nextPoint - currentPoint)
            if pointNeeded > 0 {
              self.nextRankLabel.attributedText = self
                .addAttributedText(text: pointNeeded.formattedWithSeparator,
                                   text2: self.presenter.listLevels[safe: index + 1]?.membershipLevelName ?? "")
            } else {
              self.nextRankLabel.text = "personal.max_rank".localized
            }
            if nextPoint != 0 {
                self.progressBar.progress = Float(currentPoint)/Float(nextPoint)
            } else {
                self.progressBar.progress = 0
            }
        }
    }
    func addAttributedTextPointWillExprie(point: String, date: String) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        
        let attribute1 = NSAttributedString(string: point,
                                            attributes: [.font: UIFont(name: AppFontName.medium, size: 24.0)!,
                                                         .foregroundColor: UIColor(hexString: "E71D28")!,
                                                         .paragraphStyle: paragraph])
        let attribute2 = NSAttributedString(string: String(format: "personal.point_will_exprie2".localized, date),
                                            attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                         .foregroundColor: UIColor(hexString: "727C88")!,
                                                         .paragraphStyle: paragraph])
        
        let attribute = NSMutableAttributedString()
        attribute.append(attribute1)
        attribute.append(attribute2)
        
        return attribute
    }
    func addAttributedText(text: String, text2: String) -> NSMutableAttributedString {
      let paragraph = NSMutableParagraphStyle()
      paragraph.alignment = .center
      paragraph.lineSpacing = 8.0
      let attribute1 = NSAttributedString(string: "personal.you_need1".localized,
                                         attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                      .foregroundColor: UIColor(hexString: "727C88")!,
                                                      .paragraphStyle: paragraph])
      let attribute2 = NSAttributedString(string: text,
                                         attributes: [.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                                      .foregroundColor: UIColor(hexString: "000000")!,
                                                      .paragraphStyle: paragraph])
      let attribute3 = NSAttributedString(string: "personal.you_need2".localized,
                                         attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                      .foregroundColor: UIColor(hexString: "727C88")!,
                                                      .paragraphStyle: paragraph])
      let attribute4 = NSAttributedString(string: text2,
                                          attributes: [.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                                       .foregroundColor: UIColor(hexString: "000000")!,
                                                       .paragraphStyle: paragraph])
      let attribute = NSMutableAttributedString()
      attribute.append(attribute1)
      attribute.append(attribute2)
      attribute.append(attribute3)
      attribute.append(attribute4)
      return attribute
    }

    func customizeRightBarButton() {
        let history = UIBarButtonItem(image: UIImage(named: "History"), style: .plain, target: self, action: #selector(tappedOnHistory))
        history.tintColor = UIColor(hexString: "#032041")
        self.navigationItem.rightBarButtonItem  = history
    }

    @objc private func tappedOnHistory() {
       /* let storyboard = UIStoryboard(name: "MonthHistory", bundle: nil)
        let tab = CategoryTabViewController()
        tab.title = "personal.history".localized

        let redeemVC = storyboard.instantiateViewController(withIdentifier: "MonthHistoryViewController") as! MonthHistoryViewController
        redeemVC.setType(type: .redeem)

        let rewardVC = storyboard.instantiateViewController(withIdentifier: "MonthHistoryViewController") as! MonthHistoryViewController
        rewardVC.setType(type: .reward)

        let tabs = [
            CategoryTab(title: "personal.all_point".localized,
                        viewController: AllHistoryViewController()),
            CategoryTab(title: "personal.gather_point".localized,
                        viewController: rewardVC),
            CategoryTab(title: "personal.spending_point".localized,
                        viewController: redeemVC)
        ]
        tab.setTitles(categoryTabs: tabs, distribution: .segmented, swipeToScroll: false)
        navigationController?.pushViewController(tab, animated: true)*/
        let storyboard = UIStoryboard(name: "PointInfo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "PointInfoViewController") as! PointInfoViewController
        viewController.dataCustomerBalanceDetail = self.presenter.dataCustomerBalanceDetail
        viewController.listLevels = self.presenter.listLevels
        navigationController?.pushViewController(viewController, animated: true)
    }
  
    func display(size: CGSize) {
      DispatchQueue.main.async {
        self.rankingPrivilegeHeightConstraint.constant = size.height + 50
      }
    }
}

extension MemberShipLevelViewController: MembershipPrivilegeProtocols {
    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }
    
    func showListLevels() {
        initView(listLevels: self.presenter.listLevels)
        for (index, level) in presenter.listLevels.enumerated() where level.levelStartAtDate != nil {
            display(currentLevel: level, index: index)
        }
    }
    func showPointExprie() {
        showPointExprieToView(listAllCurrencyPools: self.presenter.listAllCurrencyPools)
    }
}

extension MemberShipLevelViewController: DidLayoutMembershipPrivilegeProtocol {
  func updateLayout(size: CGSize) {
    self.display(size: size)
  }
}
