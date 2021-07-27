//
//  CashbackDetailViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 7/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SafariServices

class CashbackDetailViewController: BaseViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let presenter = CashbackDetailPresenter()

    private enum Section: Int, CaseIterable {
        case header = 0, categories, content
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chi tiết đối tác"
        customizeBackButton()
        navigationController?.setNavigationBarHidden(false, animated: true)

        presenter.delegate = self
        configTableView()
    }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: CashbackDetailHeaderTableViewCell.cellId,
                                 bundle: nil),
                           forCellReuseIdentifier: CashbackDetailHeaderTableViewCell.cellId)
        tableView.register(UINib(nibName: CashbackDetailCategoryTableViewCell.cellId,
                                 bundle: nil),
                           forCellReuseIdentifier: CashbackDetailCategoryTableViewCell.cellId)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            presenter.requestData()
        }
    }

    func setId(_ id: String?) {
        presenter.id = id ?? ""
    }

    @IBAction private func onBuy(_ sender: Any) {
        if presenter.cannotOpenBrandWebsite {
            showAlert(title: "Lỗi", message: "Không tìm thấy website nhãn hàng!")
        } else {
            presenter.recordClickRequest()
        }
    }
}

extension CashbackDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case Section.header.rawValue:
            return dequeueCashbackDetailHeaderTableViewCell(tableView, cellForRowAt: indexPath)
        case Section.categories.rawValue:
            return dequeueCashbackDetailCategoryTableViewCell(tableView, cellForRowAt: indexPath)
        default:
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
    }

    private func dequeueCashbackDetailHeaderTableViewCell(_ tableView: UITableView,
                                                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: CashbackDetailHeaderTableViewCell.cellId) as? CashbackDetailHeaderTableViewCell {
            cell.setData(presenter.model?.header)
            return cell
        }
        return UITableViewCell()
    }

    private func dequeueCashbackDetailCategoryTableViewCell(_ tableView: UITableView,
                                                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: CashbackDetailCategoryTableViewCell.cellId) as? CashbackDetailCategoryTableViewCell {
            cell.setData(presenter.model?.categories)
            return cell
        }
        return UITableViewCell()
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
        if section == Section.content.rawValue {
            return presenter.displayItems.count
        }
        if section == Section.categories.rawValue {
            if let categories = presenter.model?.categories, !categories.isEmpty {
                return 1
            }
            return 0
        }
        return 1
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == Section.content.rawValue {
            let type = presenter.displayItems[indexPath.row].type
            if type == .pageLink {
                return 120
            }
        }
        return UITableView.automaticDimension
    }
}

extension CashbackDetailViewController: CashbackDetailProtocol {
    func requestSuccess() {
        tableView.reloadData()
    }

    func showBrandWebsite() {
        guard let website = presenter.model?.header.urlString,
            let url = URL(string: website) else { return }
        url.resolveWithCompletionHandler { newUrl in
            DispatchQueue.main.async {
                UIApplication.shared.open(newUrl,
                                          options: [:],
                                          completionHandler: nil)
            }
        } 
    }
}

private extension URL {
    func resolveWithCompletionHandler(completion: @escaping (URL) -> Void) {
        let originalURL = self
        var req = URLRequest(url: originalURL)
        req.httpMethod = "HEAD"

        Loading.startAnimation()
        URLSession.shared.dataTask(with: req) { _, response, _ in
            Loading.stopAnimation()
            completion(response?.url ?? originalURL)
        }.resume()
    }
}
