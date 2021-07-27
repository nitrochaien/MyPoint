//
//  IntroductionViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class IntroductionViewController: BaseViewController {

    @IBOutlet private weak var troubleshootingView: TroubleshootingView!
    @IBOutlet private weak var tableView: UITableView!

    private let presenter = IntroductionPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "support.intro".localized
        customizeBackButton()
        configTroubleshootingView()

        presenter.delegate = self

        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.getIntroduction()
            presenter.setTroubleshootingConfig()
        }
    }

    private func configTroubleshootingView() {
        troubleshootingView.hide()
        troubleshootingView.didChangeSwitch = { [weak self] isOn in
            guard let self = self else { return }
            self.showTwoButtonsAlert(with: .troubleshootingAlert,
                                     leftButtonCompletion: { [weak self] in                                         self?.troubleshootingView.updateSwitch(!isOn)
            }) { [weak self] in
                if isOn {
                    CommonAPI.updateTemp()
                } else {
                    CommonAPI.reset()
                }
                self?.setRoot(storyboard: "Authenciation", viewControllerId: "LoginViewController")
            }
        }
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: "PageHeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageHeaderTableViewCell")
        tableView.register(UINib(nibName: "PageTextTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageTextTableViewCell")
        tableView.register(UINib(nibName: "PageImageTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageImageTableViewCell")
        tableView.register(UINib(nibName: "PageVoucherTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageVoucherTableViewCell")
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NewsTableViewCell")
    }

    deinit {
        print("Deinit IntroductionViewController")
    }
}

extension IntroductionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = presenter.displayItems[indexPath.row]

        switch item.type {
        case .header:
            return headerCell(tableView, indexPath: indexPath)
        case .text:
            return textCell(tableView, indexPath: indexPath)
        case .image:
            return imageCell(tableView, indexPath: indexPath)
        case .voucher:
            return voucherCell(tableView, indexPath: indexPath)
        case .pageLink:
            return newsCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func headerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageHeaderTableViewCell") as? PageHeaderTableViewCell {
            if let header = presenter.displayItems[indexPath.row] as? NewsDetailPresenter.Header {
                cell.setData(header)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func textCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageTextTableViewCell") as? PageTextTableViewCell {
            if let page = presenter.displayItems[indexPath.row] as? NewsDetailPresenter.GeneralPage {
                cell.setData(page)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func imageCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageImageTableViewCell") as? PageImageTableViewCell {
            if let page = presenter.displayItems[indexPath.row] as? NewsDetailPresenter.GeneralPage {
                cell.setData(page)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func voucherCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageVoucherTableViewCell") as? PageVoucherTableViewCell {
            if let page = presenter.displayItems[indexPath.row] as? NewsDetailPresenter.GeneralPage {
                cell.setData(page)
                cell.openVoucher = { [weak self] in
                    let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
                    let viewController = storyboard
                        .instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
                    viewController?.voucherId = page.contentText
                    self?.navigationController?.pushViewController(viewController!, animated: true)
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    private func newsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            if let page = presenter.displayItems[indexPath.row] as? NewsModel {
                cell.setData(from: page)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.displayItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if presenter.displayItems[indexPath.row].type == .pageLink {
            return 120
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.displayItems[indexPath.row]
        if item.type == .pageLink {
            let vc = NewsDetailViewController()
            let id = (item as? NewsModel)?.id ?? ""
            vc.setPageId(id)
            navigationController?.pushViewController(vc)
        }
    }
}

extension IntroductionViewController: IntroductionPresenterProtocol {
    func requestSuccess() {
        tableView.reloadData()
    }

    func didGetTroubleshootingConfig(_ enableMode: Bool) {
        if enableMode {
            troubleshootingView.updateSwitch(CommonAPI.isUsingDevAPI)
            troubleshootingView.show()
        }
    }
}
