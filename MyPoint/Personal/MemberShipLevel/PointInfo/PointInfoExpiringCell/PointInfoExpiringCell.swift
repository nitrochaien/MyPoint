//
//  PointInfoExpiringCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class PointInfoExpiringCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var expiringLabel: UILabel!
  @IBOutlet weak var tableView: ContentWrappingTableView!
  @IBOutlet weak var useButton: UIButton!
  @IBOutlet weak var containerView: UIView!
    var listBalanceDetails: [BalanceDetails] = []
  
  override func awakeFromNib() {
        super.awakeFromNib()
        useButton.setTitle("voucher.exchange_voucher".localized, for: .normal)
        useButton.backgroundColor = UIColor(hexString: "#1556FC")
        useButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        useButton.isHidden = true
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 0
        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)
        // Initialization code
        configTableView()
    }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "ExpiringPointCell",
          bundle: nil), forCellReuseIdentifier: "ExpiringPointCell")
  }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func useButtonTapped(_ sender: Any) {
      
    }
    func showData(data: [BalanceDetails]) {
        self.listBalanceDetails = data
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBalanceDetails.count
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "ExpiringPointCell", for: indexPath) as? ExpiringPointCell else {
            fatalError("Empty Cell")
        }
        cell.showData(data: listBalanceDetails[indexPath.row])
      print("table view height: \(tableView.intrinsicContentSize.height)")
      return cell
    }
}
