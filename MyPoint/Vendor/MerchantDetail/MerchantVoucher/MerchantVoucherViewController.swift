//
//  MerchantVoucherViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol DidLayoutMerchantVoucherProtocol: NSObjectProtocol {
    func updateMerchantVoucherLayout(size: CGSize)
  
    func updateMerchantVoucherLayout(height: CGFloat)
}

class MerchantVoucherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PagerObserver {
  
  @IBOutlet weak var tableView: UITableView!
  
  var brandId = ""
  
  private let presenter = MerchantDetailPresenter()
  
  weak var delegate: DidLayoutMerchantVoucherProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presenter.delegate = self
    configTableView()
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
  }
  
  func configTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
  }
  
  func dequeVoucherCell(indexPath: IndexPath) -> UITableViewCell {
      guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else {
            fatalError("Empty Cell")
        }
       cell.setData(voucher: presenter.listHotVoucher[indexPath.row])
       cell.selectionStyle = .none
       return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 110
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.listHotVoucher.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    dequeVoucherCell(indexPath: indexPath)
  }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
        viewController?.voucherId = presenter.listHotVoucher[safe: indexPath.row]?.voucherID ?? ""
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.pushViewController(viewController!, animated: true)
    }
  
  func needsToLoadData(index: Int) {
    presenter.getListAllVoucherByBrand(brandId: brandId)
  }
  
  func loadAlways(index: Int) {
    presenter.getListAllVoucherByBrand(brandId: brandId)
  }
}

extension MerchantVoucherViewController: MerchantDetailProtocols {
  func didUnlikeBrand() {
    
  }
  
  func didLikeBrand() {
    
  }
  
  func showListStoreByBrand() {
    
  }
  
  func showError(message: String) {
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func display(brand: BrandDetail) {
    
  }
  
  func showListVoucherByBrand() {
    tableView.reloadData()
    delegate?.updateMerchantVoucherLayout(height: CGFloat(presenter.listHotVoucher.count * 130) + 80)
  }
  
}
