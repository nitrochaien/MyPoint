//
//  RankingViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/12/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class RankingViewController: BaseViewController, PagerObserver, UITableViewDelegate, UITableViewDataSource {
    
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var myRankHeaderLabel: UILabel!
  @IBOutlet weak var rankLabel: UILabel!
  @IBOutlet weak var rankPointLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var rankImageView: UIImageView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var myRankContainerView: UIView!
    
  private var index = 0
  
  private let presenter = RankingPresenter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configTableView()
    presenter.delegate = self
    presenter.getListRanking()
    rankPointLabel.textColor = UIColor(hexString: "36399C")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
    self.title = "personal.ranking".localized
    customizeBackButton()
  }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "RankingCell", bundle: nil), forCellReuseIdentifier: "RankingCell")
  }
  
  func dequeueRankingCell(indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath) as? RankingCell
      else {
        fatalError("Empty Cell")
    }
    cell.setData(presenter.listCustomer[indexPath.row])
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.listCustomer.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 80
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    dequeueRankingCell(indexPath: indexPath)
  }
  
  func needsToLoadData(index: Int) {
    
  }
  
}

extension RankingViewController: RankingProtocols {
    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }
    
    func showListRanking() {
        let storage = Storage.shared
      for customer in presenter.listCustomer {
        if  customer.customerSiteId == storage.loginData?.workerSite?.id {
            DispatchQueue.main.async {
              self.myRankContainerView.isHidden = false
              self.nameLabel.text = customer.name
        //            self.avatarImageView
              self.rankPointLabel.text = customer.value + " Điểm"
              switch customer.rank {
              case 1:
                  self.rankImageView.isHidden = false
                  self.rankImageView.image = UIImage(named: "Group 237")
              case 2:
                   self.rankImageView.isHidden = false
                   self.rankImageView.image = UIImage(named: "Group 241")
              case 3:
                   self.rankImageView.isHidden = false
                   self.rankImageView.image = UIImage(named: "Group 242")
              default:
                   self.rankLabel.isHidden = false
                   self.rankLabel.text = String(customer.rank)
                }
            }
        } else {
          self.myRankContainerView.isHidden = true
        }
      }
        tableView.reloadData()
    }
}
