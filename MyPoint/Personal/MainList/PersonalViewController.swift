//
//  PersonalViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class PersonalViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var userInfoView: UIView!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var memberShipLevelView: UIView!
    @IBOutlet private weak var badgeImageView: UIImageView!
    @IBOutlet private weak var levelLabel: UILabel!
    
    private let cellIdentifier = "cell"
    let presenter = PersonalPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        configTableView()
        addTapGestureToUserInfoView()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

        presenter.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func applicationDidBecomeActive() {
        tableView.isUserInteractionEnabled = true
    }

    @objc private func onKeyboardWillHide() {
        tableView.isUserInteractionEnabled = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        let visibleCells = tableView.visibleCells
        for cell in visibleCells {
            if let cell = cell as? EnterCodeSuggestionTableViewCell {
                cell.resignKeyboard()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.checkSubmitReferenceCode()
        } else {
            updateBalance(isShowLoadding: false) { [weak self] in
                print("Updated balance")
                self?.configUserInfo()
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.isUserInteractionEnabled = true
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func addTapGestureToUserInfoView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTapUserInfoView))
        userInfoView.addGestureRecognizer(tap)
        let tapLevel = UITapGestureRecognizer(target: self, action: #selector(onTapUserMemberShipLevelView))
        memberShipLevelView.addGestureRecognizer(tapLevel)
    }

    private func configUserInfo() {
        let userData = Storage.shared.loginData
        avatarImageView.image = userData?.workerSite?.image
        nicknameLabel.text = userData?.workerSite?.usernameDisplay
        emailLabel.text = userData?.workerSite?.email
        pointLabel.text = userData?.workingSite?.customerBalance?.amountActiveDisplay

        let memberShip = userData?.workingSite?.primaryMembership?.membershipLevel
        levelLabel.text = memberShip?.levelName
        levelLabel.textColor = .white // UIColor(hexString: memberShip?.levelTextColor ?? "")
        badgeImageView.setImage(withURL: memberShip?.levelLogo)
    }

    @objc private func onTapUserInfoView() {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") {
            navigationController?.pushViewController(vc)
        }
    }
  
    @objc private func onTapUserMemberShipLevelView() {
        let storyboard = UIStoryboard(name: "MemberShipLevel", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MemberShipLevelViewController")
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller)
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.contentInset = .init(top: -24, left: 0, bottom: 0, right: 0)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(UINib(nibName: "EnterCodeSuggestionTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "EnterCodeSuggestionTableViewCell")

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refresh
    }

    @objc private func onRefresh() {
        presenter.generateMenu()
    }
}

extension PersonalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !presenter.didEnterInvitationCode && indexPath.section == 0 {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "EnterCodeSuggestionTableViewCell") as? EnterCodeSuggestionTableViewCell {
                cell.didConfirm = { code in
                    self.presenter.submitReferenceCode(code)
                }
                cell.didDismiss = {
                    Storage.shared.didDismissEnterInvitationCode = true
                    self.tableView.reloadData()
                }
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell.selectionStyle = .none

            let section = presenter.didEnterInvitationCode ? indexPath.section : indexPath.section - 1
            let item = presenter.menu[section][indexPath.row]
            if item.icon.isEmpty {
                cell.imageView?.image = UIImage(named: "alter")
            } else {
                cell.imageView?.image = UIImage(named: item.icon)
            }
            cell.textLabel?.text = String(format: "%@.%@", "personal", item.title).localized
            cell.textLabel?.textColor = UIColor(hexString: item.titleColor)
            if item.accessory.isEmpty {
                cell.accessoryView = nil
            } else {
                cell.accessoryView = UIImageView(image: UIImage(named: item.accessory))
            }

            return cell
        }
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        let count = presenter.menu.count
        if count == 0 { return count }

        return presenter.didEnterInvitationCode ? count : count + 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.didEnterInvitationCode {
            if section == 0 {
                return presenter.menu[section].count - 1
            }
            return presenter.menu[section].count
        }

        if section == 0 {
            return Storage.shared.didDismissEnterInvitationCode ? 0 : 1
        }
        return presenter.menu[section - 1].count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.isUserInteractionEnabled = false
        let section = presenter.didEnterInvitationCode ? indexPath.section : indexPath.section - 1
        guard let id = presenter.menu[safe: section]?[safe: indexPath.row]?.id else { return }

        switch id {
        case PersonalMenu.settings.rawValue:
            showSettings()
        case PersonalMenu.checkIn.rawValue:
            showCheckIn()
        case PersonalMenu.gift.rawValue:
            showGivePoint()
        case PersonalMenu.promotion.rawValue:
            showMyVoucher()
        case PersonalMenu.support.rawValue:
            showSupport()
        case PersonalMenu.pointHunting.rawValue:
            showPointHunting()
        case PersonalMenu.favorite.rawValue:
            showFavorite()
        case PersonalMenu.exchangePoint.rawValue:
            showChangePoint()
        case PersonalMenu.inviteFriends.rawValue:
            showInviteFriend()
        case PersonalMenu.history.rawValue:
            showHistory()
        case PersonalMenu.info.rawValue:
            showInfo()
        case PersonalMenu.rating.rawValue:
            showAppStore()
        case PersonalMenu.enterCode.rawValue:
            showEnterInvitationCode()
        case PersonalMenu.signOut.rawValue:
            showTwoButtonsAlert(with: .logoutAlert,
                                rightButtonCompletion: { [weak self] in
                self?.presenter.logout()
            })
        default:
            showCustomAlert(withTitle: "Hế lô Tester",
                            andContent: "Chức năng này tạm thời chưa có nha ^^. Chúc 1 ngày tốt lành, mãi yêu <3")
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 6
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 6
    }
}

extension PersonalViewController: PersonalProtocols {
    func requestSuccess() {
        tableView.refreshControl?.endRefreshing()
        tableView.reloadData()
        configUserInfo()
    }

    func didConfirmCode() {
        showSubmitInviteCodeSuccess()
    }

    func handleSameUserPhone() {
        showCustomAlert(withTitle: "give_point.duplicated".localized,
                        andContent: "give_point.duplicated_phone".localized)
    }

    private func showSubmitInviteCodeSuccess() {
        self.view.endEditing(true)

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = CheckinSuccessViewController()
        contentViewController.points = presenter.invitationReward
        contentViewController.screenType = .invite
        contentViewController.didConfirm = {
            self.presenter.didEnterInvitationCode = true
            self.configUserInfo()
            self.tableView.reloadData()
        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
}
