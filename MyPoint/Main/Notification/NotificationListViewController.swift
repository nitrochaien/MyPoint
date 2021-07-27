//
//  NotificationListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/9/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class NotificationListViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var notiView: UnreadNotificationView!
    @IBOutlet private weak var notiViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noDataView: EmptyNotificationView!

    private let refreshControl = UIRefreshControl()
    private let presenter = NotificationListPresenter()

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit NotificationListViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()

        configTableView()

        presenter.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.refresh()
    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.post(name: NotificationName.didLeaveNotificationScreen, object: nil)
    }

    private func configNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "notification.view_controller_header".localized

        customizeBackButton()

        let trashButton = UIBarButtonItem(image: UIImage(named: "ic_trash"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(onTapTrashButton))
        trashButton.tintColor = UIColor(hexString: "#032041")
        navigationItem.rightBarButtonItem = trashButton
    }

    @objc private func onTapTrashButton() {
        showTwoButtonsAlert(with: .notificationDeleteAllAlert, rightButtonCompletion: { [weak self] in
            self?.presenter.deleteAllNotifications()
        })
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "NotificationTableViewCell",
                                 bundle: nil),
                           forCellReuseIdentifier: "NotificationTableViewCell")

        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func onPullToRefresh() {
        presenter.refresh()
    }

    func toggleNotiView(isShow: Bool) {
        if isShow {
            let showTime = Defines.notificationViewShowTime
            DispatchQueue.main.asyncAfter(deadline: .now() + showTime) {
                self.toggleNotiView(isShow: false)
            }
        }
        notiViewTopConstraint.constant = isShow ? 0 : -40
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
            self.tableView.contentInset.top = isShow ? 32 : 0
        }) { completed in
            if completed {
                self.notiView.backgroundColor = isShow ? UIColor(hexString: "#1EB36C") : .white
            }
        }
    }
}

extension NotificationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "NotificationTableViewCell") as? NotificationTableViewCell {
            if let item = presenter.data[safe: indexPath.row] {
                cell.setData(item)
            }

            if indexPath.row == presenter.data.count - 1 {
                presenter.loadMore()
            }

            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive,
                                          title: "notification.delete".localized) { [weak self] (_, _) in
                                            self?.presenter.deleteNotification(at: indexPath.row)
        }
        return [delete]
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.markNotificationAsSeen(at: indexPath.row)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.data.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension NotificationListViewController: NotificationListPresenterDelegate {
    func requestSuccess() {
        let count = presenter.data.count
        noDataView.isHidden = count > 0

        if presenter.unreadItems > 0 {
            notiView.setTitle(String(format: "notification.noti".localized, presenter.unreadItems))
            toggleNotiView(isShow: true)
        }

        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }

    func didDeleteNotification(index: Int) {
        presenter.data.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)],
                             with: .automatic)
    }

    func didMarkNotification(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        let item = presenter.data[indexPath.row]
        item.hasSeen = true
        tableView.reloadRows(at: [indexPath], with: .automatic)

        let param = item.clickAction.isEmpty ? item.id : item.clickActionParams
        ClickActionType.showViewController(withType: item.clickAction,
                                           andParam: param,
                                           from: self.navigationController)
    }
}
