//
//  CategoryViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/14/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

final class CategoryViewController: UIViewController, PagerObserver,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!

    var category = Category()
    private let refreshControl = UIRefreshControl()
    private let presenter = CategoryListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        configCollectionView()
        presenter.delegate = self
        presenter.getListVoucherByCategories(category: category)
        presenter.category = category
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func initView() {
        refreshControl.tintColor = .clear
    }

    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BrandCell", bundle: nil),
                                     forCellWithReuseIdentifier: "BrandCell")
        self.collectionView.register(UINib(nibName: "HotVoucherCell", bundle: nil),
                                     forCellWithReuseIdentifier: "HotVoucherCell")
        self.collectionView.register(UINib(nibName: "NewsHeaderCell", bundle: nil),
                                     forCellWithReuseIdentifier: "NewsHeaderCell")
        self.collectionView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
        self.collectionView.register(UINib(nibName: "SuggestionCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "SuggestionCollectionViewCell")
        self.collectionView.register(UINib(nibName: "SuggestionHeaderCell", bundle: nil),
                                     forCellWithReuseIdentifier: "SuggestionHeaderCell")
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    @objc private func onPullToRefresh() {
        presenter.refresh()
    }

    func dequeueBrandCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as? BrandCell else {
            fatalError("Empty Cell")
        }
        cell.listBrand = presenter.listBrand
        cell.setupBrandCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height), brandHeaderText: "main.brand".localized)
        return cell
    }

    // MARK: - Deque Cell
    func dequeueHotVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotVoucherCell", for: indexPath) as? HotVoucherCell else {
            fatalError("Empty Cell")
        }
        cell.listHotVoucher = presenter.listHotVoucher
        cell.category = self.category
        cell.hotVoucherHeaderLabel.text = "main.hot_voucher".localized
        cell.setupHotVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height))
        return cell
    }

    func dequeueSuggestionHeaderCell(indexPath: IndexPath) -> UICollectionViewCell {
        //      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionHeaderCell", for: indexPath) as? SuggestionHeaderCell else {
        //          fatalError("Empty Cell")
        //      }
        //      return cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else {
            fatalError("Empty Cell")
        }
        cell.newsHeaderLabel.text = "main.suggestion".localized
        cell.viewAllButton.isHidden = true
        return cell
    }

    func dequeueSuggestionCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestionCollectionViewCell",
                                                            for: indexPath) as? SuggestionCollectionViewCell else {
                                                                fatalError("Empty Cell")
        }
      if presenter.listHotVoucher.count > 0 {
        cell.setData(voucher: presenter.listVoucherByCategory[safe: indexPath.row - 2] ?? HotVoucher())
      } else {
        cell.setData(voucher: presenter.listVoucherByCategory[safe: indexPath.row - 1] ?? HotVoucher())
      }
        if indexPath.row == presenter.listVoucherByCategory.count + 1 {
            presenter.loadMore()
        }
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = presenter.listVoucherByCategory.count
        if count == 0 {
            return 1
        } else {
          if presenter.listHotVoucher.count > 0 {
            return count + 2
          } else {
            return count + 1
          }
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if presenter.listHotVoucher.count > 0 {
        switch indexPath.row {
        case 0:
            return dequeueHotVoucherCell(indexPath: indexPath)
        case 1:
            return dequeueSuggestionHeaderCell(indexPath: indexPath)
        default:
            return dequeueSuggestionCell(indexPath: indexPath)
        }
      } else {
        switch indexPath.row {
        case 0:
            return dequeueSuggestionHeaderCell(indexPath: indexPath)
        default:
            return dequeueSuggestionCell(indexPath: indexPath)
        }
      }
        //    return UICollectionViewCell(frame: CGRect.zero)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
      if presenter.listHotVoucher.count > 0 {
        switch indexPath.row {
        case 0: // hot voucher
            let height = width * 0.7 * 3 / 4 + 58
            return CGSize(width: width, height: height)
        case 1: // suggestion header
            return CGSize(width: width, height: 50)
        default: // suggestion
            return CGSize(width: width - 32, height: 110)
        }
      } else {
        switch indexPath.row {
        case 0: // suggestion header
            return CGSize(width: width, height: 50)
        default: // suggestion
            return CGSize(width: width - 32, height: 110)
        }
      }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if presenter.listHotVoucher.count > 0 {
        switch indexPath.row {
        case 0:
          return
        case 1:
          return
        default:
          let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
          let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
          viewController?.voucherId = presenter.listVoucherByCategory[safe: indexPath.row - 2]?.voucherID ?? ""
          let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
          tabbarViewController?.pushViewController(viewController!, animated: true)
        }
      } else {
        switch indexPath.row {
        case 0:
          return
        default:
          let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
          let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
          viewController?.voucherId = presenter.listVoucherByCategory[safe: indexPath.row - 2]?.voucherID ?? ""
          let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
          tabbarViewController?.pushViewController(viewController!, animated: true)
        }
      }
    }

    func needsToLoadData(index: Int) {

    }
}

extension CategoryViewController: CategoryListProtocols {
    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func showListHotVoucher(list: [HotVoucher]) {
        //        self.listHotVoucher = list
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        self.collectionView.reloadData()
    }

    func showListBrand(list: [Brand]) {
        //        self.listBrand = list
        self.collectionView.reloadData()
    }

    func showListSuggestion(list: [NewsItem]) {
        //        self.listNews = list
        self.collectionView.reloadData()
    }

    func reloadCollectionView() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        self.collectionView.reloadData()
    }
    
}
