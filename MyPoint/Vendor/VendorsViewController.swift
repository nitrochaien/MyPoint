//
//  VendorsViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class VendorsViewController: BaseViewController {

    private var categoryTabs = [CategoryTab]()
    private var pager: ViewPager?

    let options = ViewPagerOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        let label = UILabel()
        label.font = UIFont(name: AppFontName.medium, size: 24.0)
        label.text = "merchant.partner".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)

//        let commonStoryboard = UIStoryboard(name: "ListMerchant", bundle: nil)
//        let allVC = commonStoryboard.instantiateViewController(withIdentifier: "ListMerchantViewController") as? ListMerchantViewController
//        let newestVC = commonStoryboard.instantiateViewController(withIdentifier: "ListMerchantViewController") as? ListMerchantViewController
//        let favoriteVC = commonStoryboard.instantiateViewController(withIdentifier: "ListMerchantViewController") as? ListMerchantViewController

        let nearestStoryboard = UIStoryboard(name: "NearbyMerchant", bundle: nil)
        let nearestVC = nearestStoryboard.instantiateViewController(withIdentifier: "NearbyMerchantViewController") as? NearbyMerchantViewController
      
        let merchantStoryboard = UIStoryboard(name: "ListNewMerchant", bundle: nil)
        let merchantViewController = merchantStoryboard
            .instantiateViewController(withIdentifier: "ListNewMerchantViewController") as? ListNewMerchantViewController

        self.setTitles(categoryTabs: [
            CategoryTab(title: "merchant.brand".localized, viewController: merchantViewController!),
//            CategoryTab(title: "merchant.lastest".localized, viewController: newestVC!),
            CategoryTab(title: "merchant.store".localized, viewController: nearestVC!)
//            CategoryTab(title: "merchant.favourite".localized, viewController: favoriteVC!)
        ], distribution: .segmented, swipeToScroll: false)

        customizeRightBarButton()
      
        let newView = UIView()
        newView.backgroundColor = UIColor.white

        view = newView
        if !categoryTabs.isEmpty {
            initViewPager()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            categoryTabs.first?.viewController.needsToLoadData(index: 0)
            categoryTabs.first?.isLoaded = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(navigateToMerchantProfile),
                                               name: NotificationName.goToMerchantProfileFromStore,
                                               object: nil)
    }
  
    @objc private func navigateToMerchantProfile() {
      pager?.displayViewController(atIndex: 0)
    }
  
    func customizeRightBarButton() {
      let search = UIBarButtonItem(image: UIImage(named: "deactive"), style: .plain, target: self, action: #selector(tappedOnSearch))
      search.tintColor = UIColor(hexString: "#032041")
      self.navigationItem.rightBarButtonItem = search
    }
  
    @objc private func tappedOnSearch() {
        let vc = MerchantSearchViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc)
    }

    func setTitles(categoryTabs: [CategoryTab],
                   distribution: ViewPagerOptions.Distribution = .equal,
                   swipeToScroll: Bool = true) {
        self.categoryTabs = categoryTabs
        options.distribution = distribution
        options.isEnableSwipeToScroll = swipeToScroll
    }

    func initViewPager() {
        pager = ViewPager(viewController: self)

        options.tabType = .basic
        options.tabViewBackgroundDefaultColor = .white
        options.tabViewTextDefaultColor = UIColor(hexString: "727C88")!
        options.tabViewTextHighlightColor = UIColor(hexString: "2E51CB")!
        options.tabIndicatorViewBackgroundColor = UIColor(hexString: "2E51CB")!
        options.tabViewTextFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(rawValue: 600))
        options.tabViewBackgroundHighlightColor = .white
        pager?.setOptions(options: options)

        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)

        pager?.build()
    }
}

extension VendorsViewController: ViewPagerDataSource, ViewPagerDelegate {
    func numberOfPages() -> Int {
        return categoryTabs.count
    }

    func viewControllerAtPosition(position: Int) -> UIViewController {
        return categoryTabs[position].viewController
    }

    func tabsForPages() -> [ViewPagerTab] {
        return categoryTabs.map { category -> ViewPagerTab in
            return category.tab
        }
    }

    func startViewPagerAtIndex() -> Int {
        return 0
    }

    func didMoveToControllerAtIndex(index: Int) {
        let tab = categoryTabs[index]
        tab.viewController.didShowViewController()
        if !tab.isLoaded {
            tab.isLoaded = true
            tab.viewController.needsToLoadData(index: index)
        }
    }

    func willMoveToControllerAtIndex(index: Int) {

    }
}
