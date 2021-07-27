//
//  MainListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class MainTabListViewController: UIViewController,
UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var simpleInfoView: SimpleUserInfoView!
    @IBOutlet weak var statusBarView: UIView!
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!

    private let refreshControl = UIRefreshControl()
    private let presenter = MainListPresenter()
    private var listDefaultCategory = [Category]()

    private let numberOfNoneNewsCell = 6
    var showFirstTime = true
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        configCollectionView()

        presenter.delegate = self

        if pushUserInfo != nil {
            PushNotificationManager.shared.handlePushNotification()
        }

        presenter.updateNotificationToken()
        presenter.getListHotVoucher()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("Deinit MainTabListViewController")
    }

    func showRequireInfoIfNeeded() {
        let workerSite = Storage.shared.loginData?.workerSite
        let loggedAccounts = Storage.shared.loggedAccounts
        let currentAccount = workerSite?.phoneNumber ?? ""
        let openAppFirstTime = !loggedAccounts.contains(currentAccount)
        let didNotInputBirthday = workerSite?.birthday?.isEmpty == true
        let didNotInputName = workerSite?.nickname?.isEmpty == true && workerSite?.fullname?.isEmpty == true
        if openAppFirstTime && (didNotInputBirthday || didNotInputName) {
            Storage.shared.loggedAccounts.append(currentAccount)
            showRequireInfoPopUp { [weak self] in
                self?.reloadData()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateNotificationCount),
                                               name: NotificationName.didLeaveNotificationScreen,
                                               object: nil)
        DispatchQueue.main.async {
            self.collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getNotificationList()
        } else{
            presenter.getNotificationList(isShowLoadding: false)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showFirstTime = false
        NotificationCenter.default.post(name: NotificationName.didLeaveMainScreen, object: nil)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
  
    @objc func updateNotificationCount() {
      self.presenter.getNotificationList()
    }

    @IBAction private func didPressNotificationButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotificationListViewController")
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller)
    }
    
    func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CategoryCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCell")
        self.collectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "BannerCell")
        self.collectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "BrandCell")
        self.collectionView.register(UINib(nibName: "VoucherCell", bundle: nil), forCellWithReuseIdentifier: "VoucherCell")
        self.collectionView.register(UINib(nibName: "HotVoucherCell", bundle: nil), forCellWithReuseIdentifier: "HotVoucherCell")
        self.collectionView.register(UINib(nibName: "NewsHeaderCell", bundle: nil), forCellWithReuseIdentifier: "NewsHeaderCell")
        self.collectionView.register(UINib(nibName: "NewsCell", bundle: nil), forCellWithReuseIdentifier: "NewsCell")
        self.collectionView.register(UINib(nibName: "OperatorVoucherCell", bundle: nil),
                                     forCellWithReuseIdentifier: "OperatorVoucherCell")
        self.collectionView.register(UINib(nibName: "ProfileHeaderView", bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                     withReuseIdentifier: "ProfileHeaderView")
        refreshControl.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        //        collectionView.refreshControl = refreshControl
        collectionView.bounces = false
    }

    @objc private func onPullToRefresh() {
        presenter.refresh()
    }

    func initView() {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            statusBarHeightConstraint.constant = topPadding ?? 0
        } else {
            statusBarHeightConstraint.constant = UIApplication.shared.statusBarFrame.height
        }
        simpleInfoView.hide()
    }

    // MARK: - Deque Cell

    func dequeueCategoryCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {
            fatalError("Empty Cell")
        }
        cell.categoryCollectionView.reloadData()
        cell.categoryCollectionView.layoutIfNeeded()
        cell.listCategory = self.presenter.listCategory
        cell.setupCategoryCollectionView(frameSize: CGSize(width: cell.frame.size.width,
                                                           height: cell.frame.size.height))
        return cell
    }

    func dequeueBannerCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as? BannerCell else {
            fatalError("Empty Cell")
        }
        cell.onSelect = { banner in
            ClickActionType.showViewController(withType: banner.clickAction ?? "",
                                               andParam: banner.clickActionParams ?? "",
                                               from: self.navigationController)
        }
        cell.listBanners = presenter.listBanners
        cell.setupBannerCollectionView(frameSize: .init(width: cell.frame.size.width,
                                                        height: cell.frame.size.height))
        return cell
    }

    func dequeueBrandCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as? BrandCell else {
            fatalError("Empty Cell")
        }
        cell.onSelected = { id in
            let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantDetailViewController") as? MerchantDetailViewController
            viewController?.brandId = id
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        cell.listBrand = self.presenter.listBrand
        cell.setupBrandCollectionView(frameSize: CGSize(width: cell.frame.size.width,
                                                        height: cell.frame.size.height),
                                      brandHeaderText: "main.brand".localized)
        return cell
    }
  
    func dequeueAcumulativePointBrandCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as? BrandCell else {
            fatalError("Empty Cell")
        }
        cell.onSelected = { id in
            let storyboard = UIStoryboard(name: "MerchantDetail", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantDetailViewController") as? MerchantDetailViewController
            viewController?.brandId = id
            self.navigationController?.pushViewController(viewController!, animated: true)
        }
        cell.listBrand = self.presenter.listBrand
        cell.listCampain = []
        cell.setupBrandCollectionView(frameSize: CGSize(width: cell.frame.size.width,
                                                        height: cell.frame.size.height),
                                      brandHeaderText: "main.acumulative_point_brand".localized)
        cell.onShowAllCampaign = {
            let vc = CashbackMainViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
  
    func dequeuePointReturnBrandCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as? BrandCell else {
            fatalError("Empty Cell")
        }
        cell.onSelected = { id in
            let vc = CashbackDetailViewController()
            vc.hidesBottomBarWhenPushed = true
            vc.setId(id)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        cell.listBrand = []
        cell.listCampain = self.presenter.listCampain
        cell.setupBrandCollectionView(frameSize: CGSize(width: cell.frame.size.width,
                                                        height: cell.frame.size.height),
                                      brandHeaderText: "main.point_return_brand".localized)
        return cell
    }

    func dequeueVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VoucherCell", for: indexPath) as? VoucherCell else {
            fatalError("Empty Cell")
        }
        cell.setupVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height))
        return cell
    }

    func dequeueHotVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotVoucherCell", for: indexPath) as? HotVoucherCell else {
            fatalError("Empty Cell")
        }
        cell.listHotVoucher = self.presenter.listHotVoucher
        cell.hotVoucherHeaderLabel.text = "main.hot_voucher".localized
        cell.setupHotVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height))
        return cell
    }

    func dequeueNewsHeaderCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsHeaderCell", for: indexPath) as? NewsHeaderCell else {
            fatalError("Empty Cell")
        }
        return cell
    }

    func dequeueNewsCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            fatalError("Empty Cell")
        }
        let index = indexPath.row - numberOfNoneNewsCell
        let item = presenter.listNews[safe: index]
        cell.newsTitleLabel.text = item?.contentText
        cell.newContentLabel.attributedText = item?.subText
        if let url = URL(string: item?.contentCaption ?? "") {
            cell.newsImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
        } else {
            cell.newsImageView.image = UIImage(named: "alter")
        }
        return cell
    }
  
    func dequeueOperatorVoucherCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OperatorVoucherCell", for: indexPath) as? OperatorVoucherCell else {
            fatalError("Empty Cell")
        }
        cell.setupOperatorVoucherCollectionView(frameSize: CGSize(width: cell.frame.size.width, height: cell.frame.size.height), isFromHome: true)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let view = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: "ProfileHeaderView",
                                                  for: indexPath) as! ProfileHeaderView
            view.updateData(unread: self.presenter.unreadItems)
            return view
        default:  fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 280)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.listNews.count + numberOfNoneNewsCell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            return dequeueOperatorVoucherCell(indexPath: indexPath)
        case 1:
            return dequeueBannerCell(indexPath: indexPath)
        case 2:
            return dequeueAcumulativePointBrandCell(indexPath: indexPath)
        case 3:
            return dequeuePointReturnBrandCell(indexPath: indexPath)
        case 4:
            return dequeueHotVoucherCell(indexPath: indexPath)
        case 5:
            return dequeueNewsHeaderCell(indexPath: indexPath)
        default:
            return dequeueNewsCell(indexPath: indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0, 1, 2, 3, 4, 5:
            break
        default:
            let index = indexPath.row - numberOfNoneNewsCell
            let vc = NewsDetailViewController()
            vc.setPageId(presenter.listNews[index].id)
            vc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(vc)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.size.width
//        switch indexPath.row {
//        case 0: //brand
//            return CGSize(width: width, height: 160)
//        case 1: //banner
//            if presenter.listBanners.count > 0 {
//                return CGSize(width: width - 30, height: 200)
//            } else {
//                return CGSize(width: width - 30, height: 0)
//            }
//        case 2: //category
//            return CGSize(width: width, height: 246)
//        case 3: //hot voucher
//            let height = width * 0.7 * 3 / 4 + 58
//            return CGSize(width: width, height: height)
//        case 4: //news header
//            return CGSize(width: width, height: 58)
//        default: //news
//            return CGSize(width: width, height: 120)
//        }
      switch indexPath.row {
      case 0: // operator
          return CGSize(width: width - 24, height: 116)
      case 1: // banner
          if presenter.listBanners.count > 0 {
              return CGSize(width: width - 30, height: 200)
          } else {
              return CGSize(width: width - 30, height: 0)
          }
      case 2: //
          return CGSize(width: width, height: 160)
      case 3: //
        return CGSize(width: width, height: 160)
      case 4: // hot voucher
          let height = width * 0.7 * 3 / 4 + 58
          return CGSize(width: width, height: height)
      case 5: // news header
          return CGSize(width: width, height: 58)
      default: // news
          return CGSize(width: width, height: 120)
      }
    }
}

extension MainTabListViewController: MainListProtocols {
  
    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func showListHotVoucher(list: [HotVoucher]) {
        //        self.listHotVoucher = list
        //        self.collectionView.reloadData()
        self.presenter.getListCategory()
    }

    func showListCategory(list: [Category]) {
        for category in presenter.listCategory where category.subscribed == "1" {
            self.presenter.listSubscribedCategory.append(category)
        }
        for category in presenter.listCategory
            where category.categoryCode == "FOOD"
                || category.categoryCode == "ENTERTAINMENT"
                || category.categoryCode == "CONSUMER_GOODS" {
                    self.listDefaultCategory.append(category)
        }
        if let navController = self.tabBarController?.viewControllers?[safe: 1] as? UINavigationController {
            let secondTab = navController.topViewController as! VoucherTabListViewController
            secondTab.listSubscribedCategory = self.presenter.listSubscribedCategory
            secondTab.listDefaultCategory = self.listDefaultCategory
            self.presenter.getListBanner()
        }
    }

    func showListBanner() {
        self.presenter.getListBrand()
    }

    func showListBrand(list: [Brand]) {
//        self.presenter.getListNews()
        self.presenter.getListCampain()
    }
  
    func showListCampain(list: [Campaign]) {
        self.presenter.getListNews()
    }

    func showListNews() {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }
        showRequireInfoIfNeeded()
        reloadData()
    }

    func requestSuccess() {
        reloadData()
    }
}
