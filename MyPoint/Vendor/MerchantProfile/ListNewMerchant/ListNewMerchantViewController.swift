//
//  ListNewMerchantViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 3/23/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

final class ListNewMerchantViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PagerObserver {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  private var refreshControl = UIRefreshControl()
  private let presenter = MerchantProfilePresenter()
  
  private var index = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configCollectionView()
    presenter.delegate = self
  }
  
  func configCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    self.collectionView.register(UINib(nibName: "NewMerchantProfileCell", bundle: nil), forCellWithReuseIdentifier: "NewMerchantProfileCell")
    refreshControl.tintColor = .clear
    refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
    collectionView.refreshControl = refreshControl
  }
  
  @objc private func onPullToRefresh() {
    presenter.refresh(index: index)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ((self.view.frame.size.width / 2) - 8), height: 170)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return 0
  }
    
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
      return .init(top: 0, left: 0, bottom: 0, right: 0)
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return presenter.listBrand.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewMerchantProfileCell", for: indexPath) as? NewMerchantProfileCell
      else {
      fatalError("Empty Cell")
    }
    cell.setData(brand: presenter.listBrand[safe: indexPath.row] ?? Brand())
    if indexPath.row == presenter.listBrand.count - 1 {
      presenter.loadMoreBrand(index: index)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
         let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantDetailViewController") as? MerchantDetailViewController
         viewController?.brandId = presenter.listBrand[safe: indexPath.row]?.brandID ?? ""
         let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
         tabbarViewController?.pushViewController(viewController!, animated: true)
  }
  
  func needsToLoadData(index: Int) {
    presenter.getListBrand(index: index)
  }
}

extension ListNewMerchantViewController: MerchantProfileProtocols {
  func showError(message: String) {
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func showListMerchant() {
    
  }
  
  func reloadTableView() {
    refreshControl.endRefreshing()
    self.collectionView.reloadData()
  }
  
}
