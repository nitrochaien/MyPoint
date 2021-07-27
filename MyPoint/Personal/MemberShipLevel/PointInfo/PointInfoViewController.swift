//
//  PointInfoViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Kingfisher

final class PointInfoViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var tableView: ContentWrappingTableView!
  var dataCustomerBalanceDetail: CustomerBalanceDetail!
    var  listLevels: [Level] = []
    var listExpired: [BalanceDetails] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    let balanceDetails = dataCustomerBalanceDetail.allCurrencyPools[0].balanceDetails
    for item in balanceDetails where  item.expiredDate != nil {
        listExpired.append(item)
    }
    configTableView()
    initView()
  }
  
  func initView() {
    customizeBackButton()
    self.title = "personal.point_info".localized
  }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PointInfoCell",
          bundle: nil), forCellReuseIdentifier: "PointInfoCell")
    tableView.register(UINib(nibName: "PointInfoExpiringCell",
    bundle: nil), forCellReuseIdentifier: "PointInfoExpiringCell")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if listExpired.count > 0 {
        return 2
    }
    return 1
    
  }
  
  func dequeuePointInfoCell(indexPath: IndexPath) -> UITableViewCell {
    guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PointInfoCell", for: indexPath) as? PointInfoCell else {
          fatalError("Empty Cell")
      }
    cell.delegate = self
    cell.showData(data: dataCustomerBalanceDetail, listLevels: listLevels)
    return cell
  }
  
    func dequeuePointInfoExpiringCell(indexPath: IndexPath) -> UITableViewCell {
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PointInfoExpiringCell", for: indexPath) as? PointInfoExpiringCell else {
            fatalError("Empty Cell")
        }
        cell.showData(data: listExpired)
      return cell
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      return dequeuePointInfoCell(indexPath: indexPath)
    default:
     return dequeuePointInfoExpiringCell(indexPath: indexPath)
    }
  }
}
extension PointInfoViewController: PointInfoProtocols {
    func showPolicy() {
        let vc = FrequencyQuestionViewController()
        vc.setType(type: .agreement)
        navigationController?.pushViewController(vc, animated: true)
    }
}
