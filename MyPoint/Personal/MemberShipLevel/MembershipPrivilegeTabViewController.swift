//
//  MembershipPrivilegeTabViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class MembershipPrivilegeTabViewController: BaseViewController {

    private var rankingTabs = [RankingTab]()
    private var pager: ViewPager?

    let options = ViewPagerOptions()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false

        customizeBackButton()

        let newView = UIView()
        newView.backgroundColor = UIColor.white

        view = newView

        if !rankingTabs.isEmpty {
            initViewPager()
        }
    }

    deinit {
        print("Deinit MembershipPrivilegeTabViewController")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            rankingTabs.first?.viewController.needsToLoadData(index: 0)
        }
    }

    func setTitles(rankingTabs: [RankingTab],
                   distribution: ViewPagerOptions.Distribution = .equal,
                   swipeToScroll: Bool = true) {
        self.rankingTabs = rankingTabs
        options.distribution = distribution
        options.isEnableSwipeToScroll = swipeToScroll
    }

    func initViewPager() {
        pager = ViewPager(viewController: self)

        options.tabType = .imageWithText
        options.tabViewBackgroundDefaultColor = UIColor(hexString: "F1F3F4")!
        options.tabViewTextDefaultColor = .black
        options.tabViewTextHighlightColor = .black
        options.isTabHighlightAvailable = true
        options.isTabIndicatorAvailable = false
//        options.tabIndicatorViewBackgroundColor = UIColor(hexString: "2E51CB")!
        options.tabViewTextFont = UIFont.systemFont(ofSize: 10, weight: UIFont.Weight(rawValue: 600))
        options.tabViewBackgroundHighlightColor = .white
        options.isTabBarShadowAvailable = false
        pager?.setOptions(options: options)

        pager?.setDataSource(dataSource: self)
        pager?.setDelegate(delegate: self)

        pager?.build()
    }
}

extension MembershipPrivilegeTabViewController: ViewPagerDataSource, ViewPagerDelegate {
    func numberOfPages() -> Int {
        return rankingTabs.count
    }

    func viewControllerAtPosition(position: Int) -> UIViewController {
        return rankingTabs[position].viewController
    }

    func tabsForPages() -> [ViewPagerTab] {
        return rankingTabs.map { ranking -> ViewPagerTab in
            return ranking.tab
        }
    }

    func startViewPagerAtIndex() -> Int {
        return 0
    }

    func didMoveToControllerAtIndex(index: Int) {
        let tab = rankingTabs[index]
        tab.viewController.didShowViewController()
        if !tab.isLoaded {
            tab.isLoaded = true
            tab.viewController.needsToLoadData(index: index)
        }
    }

    func willMoveToControllerAtIndex(index: Int) {
      let tab = rankingTabs[index]
      tab.viewController.needsToLoadData(index: index)
    }
}

class RankingTab {
    let tab: ViewPagerTab
    let viewController: PagerObserver
    var isLoaded: Bool

      init(title: String, viewController: PagerObserver) {
          self.tab = ViewPagerTab(title: title, image: nil)
          self.viewController = viewController
  //        self.viewController.title = title
          self.isLoaded = false
      }
    
    init(title: String, image: UIImage, viewController: PagerObserver) {
        self.tab = ViewPagerTab(title: title, image: image)
        self.viewController = viewController
//        self.viewController.title = title
        self.isLoaded = false
    }
  
    init(title: String, image: String, viewController: PagerObserver) {
        self.tab = ViewPagerTab(title: title, image: nil)
        self.viewController = viewController
//        self.viewController.title = title
        self.isLoaded = false
    }
}
