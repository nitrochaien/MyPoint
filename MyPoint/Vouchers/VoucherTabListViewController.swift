//
//  VoucherTabListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class VoucherTabListViewController: BaseViewController,
    UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,
UISearchBarDelegate {

    @IBOutlet weak var voucherHeaderLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var curveView: CurveView!
    
    //  var listHotVoucher = [HotVoucher]()
    var listSubscribedCategory = [Category]()
    //  var listVoucherByCategory = [[HotVoucher]]()
    //  var listCategoryWithVoucher = [Category]()
    var listDefaultCategory = [Category]()

    private let refreshControl = UIRefreshControl()
    private let presenter = VoucherTabListPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        initView()
        configCollectionView()
        presenter.delegate = self
        //    for category in listSubscribedCategory {
        //        presenter.getListVoucherByCategories(categoryCode: category.categoryCode ?? "")
        //    }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshData),
                                               name: NotificationName.didChangeInterestedCategories,
                                               object: nil)
    }

    private func showCategoryPicker() {
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InterestedCategoriesViewController")
        present(vc, animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            // Check for subcribed categories
            presenter.requestCategoryList()
        }
    }

    @objc private func refreshData() {
        presenter.refresh()
    }

    deinit {
        print("Deinit VoucherTabListViewController")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        curveView.drawShape()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    func initView() {
        voucherHeaderLabel.text = "voucher.voucher".localized
        //    searchBar.searchTextField.backgroundColor = .white
        searchBar.barTintColor = UIColor.white
        searchBar.setBackgroundImage(UIImage.init(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        searchBar.textField?.backgroundColor = .white
        searchBar.shadowView(color: UIColor(red: 55/255, green: 103/255, blue: 160/255, alpha: 0.1),
                             cornerRadius: 20.0,
                             size: CGSize(width: 6, height: 20),
                             shadowRadius: 20,
                             cornerRadiusShadow: 20)
        //    searchBar.cornerRadius = 20.0
    }

    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "HotVoucherCell", bundle: nil),
                                     forCellWithReuseIdentifier: "HotVoucherCell")
        self.collectionView.register(UINib(nibName: "OperatorVoucherCell", bundle: nil),
                                     forCellWithReuseIdentifier: "OperatorVoucherCell")
        self.collectionView.register(UINib(nibName: "SuggestionCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: "SuggestionCollectionViewCell")
        self.collectionView.register(UINib(nibName: "SuggestionHeaderCell", bundle: nil),
                                     forCellWithReuseIdentifier: "SuggestionHeaderCell")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = .clear
        collectionView.refreshControl = refreshControl
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let storyboard = UIStoryboard(name: "VoucherSearch", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherSearchViewController") as? VoucherSearchViewController
        let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
        tabbarViewController?.navigationBar.isHidden = false
        tabbarViewController?.pushViewController(viewController!, animated: true)
        return false
    }

    func dequeueOperatorVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperatorVoucherCell", for: indexPath) as? OperatorVoucherCell else {
            fatalError("Empty Cell")
        }
        cell.setupOperatorVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height), isFromHome: false)
        return cell
    }

    func dequeueHotVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotVoucherCell", for: indexPath) as? HotVoucherCell else {
            fatalError("Empty Cell")
        }
        cell.listHotVoucher = self.presenter.listHotVoucher
        cell.shouldShowSales = true
        cell.hotVoucherHeaderLabel.text = "main.hot_voucher".localized
        cell.setupHotVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height))
        return cell
    }
    
    func dequeueSuggestVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "SuggestionCollectionViewCell", for: indexPath) as? SuggestionCollectionViewCell else {
            fatalError("Empty Cell")
        }
        cell.setData(voucher: self.presenter.listSuggestVoucher[safe: indexPath.row - 3] ?? HotVoucher())
        if indexPath.row == self.presenter.listSuggestVoucher.count - 1 {
            presenter.loadMore()
        }
        return cell
    }
    
    func dequeueSuggestHeaderCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "SuggestionHeaderCell", for: indexPath) as? SuggestionHeaderCell else {
            fatalError("Empty Cell")
        }
        cell.setData(string: "voucher.all_voucher".localized)
        return cell
    }

    func dequeueDefaultVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: "HotVoucherCell", for: indexPath) as? HotVoucherCell else {
            fatalError("Empty Cell")
        }

        let dummy = Category(id: "", subscribed: "", categoryCode: "", categoryName: "", imageUrl: "")
        let category = presenter.listCategoryWithVoucher[safe: indexPath.row - 2]

        cell.listHotVoucher = self.presenter.listVoucherByCategory[safe: indexPath.row - 2] ?? []
        cell.shouldShowSales = false
        cell.hotVoucherHeaderLabel.text = category?.categoryName ?? ""
        if listSubscribedCategory.count > 0 {
            cell.category = category ?? dummy
        } else {
            cell.category = self.listDefaultCategory[safe: indexPath.row - 2] ?? dummy
        }
        cell.setupHotVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height))
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //    if listSubscribedCategory.count == 0 {
        //        return listVoucherByCategory.count + 2
        //    } else {
        //        return listVoucherByCategory.count + 2
        //    }
//        return presenter.listVoucherByCategory.count + 2
        return presenter.listSuggestVoucher.count + 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
        switch indexPath.row {
        case 0: // operator
            return CGSize(width: width, height: 116)
        case 1: // hot voucher
            let height = width * 0.7 * 3 / 4 + 58
            return CGSize(width: width, height: height)
        case 2: // suggestion header
            return CGSize(width: width - 32, height: 35)
        default: // default voucher
            return CGSize(width: width - 32, height: 98)
//            let height = width * 0.7 * 3 / 4 + 108
//            return CGSize(width: width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            return dequeueOperatorVoucherCell(indexPath: indexPath)
        case 1:
            return dequeueHotVoucherCell(indexPath: indexPath)
        case 2:
            return dequeueSuggestHeaderCell(indexPath: indexPath)
            //          case 2:
            //              return dequeueHotFoodVoucherCell(indexPath: indexPath)
            //          case 3:
            //              return dequeueHotFashionVoucherCell(indexPath: indexPath)
            //          case 4:
        //              return dequeueHotEntertainmentVoucherCell(indexPath: indexPath)
        default:
            return dequeueSuggestVoucherCell(indexPath: indexPath)
//            return dequeueDefaultVoucherCell(indexPath: indexPath)
        }
        //    return UICollectionViewCell(frame: CGRect.zero)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            return
        case 2:
            return
        default:
            let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
            viewController?.voucherId = presenter.listSuggestVoucher[safe: indexPath.row - 3]?.voucherID ?? ""
            let tabbarViewController = UIApplication.shared.topViewController as? UINavigationController
            tabbarViewController?.pushViewController(viewController!, animated: true)
        }
    }
}

extension VoucherTabListViewController: VoucherTabListProtocols {

    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func showListHotVoucher(list: [HotVoucher]) {
        //        self.listHotVoucher = list
//        presenter.getListSubscribedCategory()
        presenter.getListSuggestVoucher()
    }

    func showListCategory(list: [Category]) {
        self.listSubscribedCategory = list
        if listSubscribedCategory.count > 0 {
            presenter.getListVoucherByCategories(listCategory: listSubscribedCategory)
        } else {
            presenter.getListVoucherByCategories(listCategory: listDefaultCategory)
        }
    }

    func showListVoucherByCategory(listVoucher: [HotVoucher], category: Category) {
        //    self.listVoucherByCategory.append(listVoucher)
        //    self.listCategoryWithVoucher.append(category)
        //    print("list voucher 123: \(listVoucherByCategory)")
        //    self.collectionView.reloadData()
    }

    func reloadCollectionView() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        self.collectionView.reloadData()
    }

    func handleDidCheckForSubcribeCategory(subcribed: Bool) {
        if subcribed {
            presenter.refresh()
        } else {
            if Storage.shared.didNotShowVoucherTab {
                Storage.shared.didNotShowVoucherTab = false
                showCategoryPicker()
            } else {
                presenter.refresh()
            }
        }
    }
}
