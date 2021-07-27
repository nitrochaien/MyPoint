//
//  ListVoucherViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/7/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class ListVoucherViewController: BaseViewController,
UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var category = Category(id: "", subscribed: "", categoryCode: "", categoryName: "", imageUrl: "")

    private let refreshControl = UIRefreshControl()
    private let presenter = ListVoucherPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        if category.categoryName == "" {
            self.title = "main.hot_voucher".localized
        } else {
            self.title = category.categoryName
        }
        presenter.category = category
        presenter.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl

        if category.categoryCode != "" {
            presenter.category = category
            presenter.getListVoucherByCategories(category: category)
        } else {
            presenter.getListHotVoucher()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc private func onPullToRefresh() {
        presenter.refresh()
    }

    func dequeSuggestCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else {
            fatalError("Empty Cell")
        }
        cell.setData(voucher: presenter.listHotVoucher[safe: indexPath.row])

        if indexPath.row == presenter.listHotVoucher.count - 1 {
            presenter.loadMore()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
      return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.listHotVoucher.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        dequeSuggestCell(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
        viewController?.voucherId = presenter.listHotVoucher[safe: indexPath.row]?.voucherID ?? ""
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(viewController!, animated: true)

    }

}

extension ListVoucherViewController: ListVoucherProtocols {
    func showListVoucherByCategory(list: [HotVoucher]) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }
    
    func showListHotVoucher(list: [HotVoucher]) {
        //      self.listHotVoucher = list
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        self.tableView.reloadData()
    }

    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }
}
