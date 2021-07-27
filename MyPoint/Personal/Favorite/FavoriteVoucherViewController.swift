//
//  FavoriteVoucherViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/2/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import SwipeCellKit

class FavoriteVoucherViewController: UIViewController, PagerObserver, UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var undoHeaderLabel: UILabel!
    @IBOutlet weak var undoButton: UIButton!
    
    private var refreshControl = UIRefreshControl()
    
    private var index = 0
  
    private let presenter = FavouritePresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configTableView()
        presenter.delegate = self
    }
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      print("self index: \(self.index)")
      presenter.refresh(index: self.index)
    }
    
    func initView() {
        undoView.isHidden = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(hideUndoView))
//        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideUndoView() {
        undoView.isHidden = true
    }
    
    func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = true
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "SuggestCell", bundle: nil), forCellReuseIdentifier: "SuggestCell")
        tableView.register(UINib(nibName: "FavouriteBrandCell", bundle: nil), forCellReuseIdentifier: "FavouriteBrandCell")
        tableView.registerEmptyCell()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
  
    @objc private func onPullToRefresh() {
      presenter.refresh(index: index)
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataCount = index == 0 ? presenter.listFavouriteVoucher.count : presenter.listFavouriteBrand.count
        return dataCount == 0 ? 1 : dataCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dataCount = index == 0 ? presenter.listFavouriteVoucher.count : presenter.listFavouriteBrand.count
        if index == 0 {
          return dataCount == 0 ? UIScreen.main.bounds.height / 2 : 110
        } else {
          return dataCount == 0 ? UIScreen.main.bounds.height / 2 : UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCount = index == 0 ? presenter.listFavouriteVoucher.count : presenter.listFavouriteBrand.count
        if dataCount == 0 {
            if let cell = tableView
                .dequeueReusableCell(withIdentifier: "NoDataVoucherTableViewCell") as? NoDataVoucherTableViewCell {
                let title = index == 0 ? "voucher.no_fav_voucher".localized : "voucher.no_fav_brand".localized
                cell.emptyLabel.text = title
                return cell
            }
            return UITableViewCell()
        }

        if self.index == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "SuggestCell", for: indexPath) as? SuggestCell else {
                  fatalError("Empty Cell")
              }
              cell.selectionStyle = .none
              cell.delegate = self
              cell.setData(voucher: presenter.listFavouriteVoucher[indexPath.row].detail)
              if indexPath.row == presenter.listFavouriteVoucher.count - 1 {
                presenter.loadMore(index: self.index)
              }
              return cell
        } else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "FavouriteBrandCell", for: indexPath) as? FavouriteBrandCell else {
                  fatalError("Empty Cell")
              }
            cell.setData(brand: presenter.listFavouriteBrand[indexPath.row].detail ?? Brand())
            if indexPath.row == presenter.listFavouriteBrand.count - 1 {
              presenter.loadMore(index: self.index)
            }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let dataCount = index == 0 ? presenter.listFavouriteVoucher.count : presenter.listFavouriteBrand.count
        if dataCount == 0 { return nil }

        guard orientation == .left else { return nil }
        let delete = SwipeAction(style: .destructive, title: "Bỏ thích") { _, _ in
          if self.index == 0 {
            self.presenter.unlikeVoucher(at: indexPath.row)
          } else {
            self.presenter.unlikeBrand(at: indexPath.row)
          }
        }
        delete.image = UIImage(named: "trash")
        return [delete]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataCount = index == 0 ? presenter.listFavouriteVoucher.count : presenter.listFavouriteBrand.count
        if dataCount == 0 { return }
        
        print("tap: \(indexPath.row)")
        if self.index == 0 {
            print("tap: \(indexPath.row)")

            let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController")
            let viewController = vc as? VoucherDetailViewController
            viewController?.voucherId = presenter.listFavouriteVoucher[safe: indexPath.row]?.detail?.voucherID ?? ""
            self.navigationController?.pushViewController(viewController!, animated: true)
        } else {
            print("tap: \(indexPath.row)")

            let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantDetailViewController") as? MerchantDetailViewController
          viewController?.brandId = presenter.listFavouriteBrand[safe: indexPath.row]?.detail?.brandID ?? ""
             self.navigationController?.pushViewController(viewController!, animated: true)
        }
    }
    
    func preloadData(index: Int) {
        self.index = index
//        presenter.refresh(index: index)
//        tableView.reloadData()
//        print("index: \(index)")
    }
  
    func loadAlways(index: Int) {
        self.index = index
//        presenter.refresh(index: index)
    }
  
    func needsToLoadData(index: Int) {
        self.index = index
//        if index == 0 {
//          presenter.refresh(index: index)
//        }
    }
}

extension FavoriteVoucherViewController: FavouriteListProtocols {
  func didUnlikeVoucher(index: Int) {
    presenter.listFavouriteVoucher.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)],
                         with: .automatic)
  }
  
  func didUnlikeBrand(index: Int) {
    presenter.listFavouriteBrand.remove(at: index)
    tableView.deleteRows(at: [IndexPath(row: index, section: 0)],
                         with: .automatic)
  }
  
  func showError(message: String) {
    tableView.reloadData()
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func showListFavouriteVoucher(list: [HotVoucher]) {
    
  }
  
  func showListFavouriteBrand(list: [Brand]) {
    
  }
  
  func reloadTableView() {
    refreshControl.endRefreshing()
    tableView.reloadData()
  }

}
