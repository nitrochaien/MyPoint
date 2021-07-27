//
//  ListMerchantViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/5/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

final class ListMerchantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagerObserver {

  @IBOutlet weak var tableView: UITableView!
  
  private var refreshControl = UIRefreshControl()
  private let presenter = MerchantProfilePresenter()
  
  private var index = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configTableView()
    presenter.delegate = self
//    presenter.getListBrand(index: index)
  }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "MerchantProfileCell", bundle: nil), forCellReuseIdentifier: "MerchantProfileCell")
    refreshControl.tintColor = .clear
    refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc private func onPullToRefresh() {
    presenter.refresh(index: index)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.listBrand.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantProfileCell", for: indexPath) as? MerchantProfileCell
      else {
        fatalError("Empty Cell")
    }
    cell.setData(brand: presenter.listBrand[safe: indexPath.row] ?? Brand())
    if indexPath.row == presenter.listBrand.count - 1 {
      presenter.loadMoreBrand(index: index)
    }
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
      let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantDetailViewController") as? MerchantDetailViewController
      viewController?.brandId = presenter.listBrand[safe: indexPath.row]?.brandID ?? ""
      let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
      tabbarViewController?.pushViewController(viewController!, animated: true)
  }
  
  func needsToLoadData(index: Int) {
    self.index = index
    presenter.getListBrand(index: index)
  }
  
  func preloadData(index: Int) {
  }
  
}

extension ListMerchantViewController: MerchantProfileProtocols {
  func showError(message: String) {
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func showListMerchant() {
    
  }
  
  func reloadTableView() {
    refreshControl.endRefreshing()
    self.tableView.reloadData()
  }
  
}
