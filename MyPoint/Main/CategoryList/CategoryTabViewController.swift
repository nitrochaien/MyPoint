//
//  CategoryListViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class CategoryTabViewController: BaseViewController {

    private var categoryTabs = [CategoryTab]()
    private var pager: ViewPager?

    var didSelectTab: ((_ index: Int, _ isLoaded: Bool) -> Void)?

    let options = ViewPagerOptions()
  
    var firstSelectedIndex = 0

    var hideNavigationBar = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = hideNavigationBar

        customizeBackButton()

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
            if firstSelectedIndex > 0 {
                pager?.scrollToIndex(firstSelectedIndex, previousIndex: 0)
            }
            categoryTabs[safe: firstSelectedIndex]?.viewController.needsToLoadData(index: firstSelectedIndex)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: true)
    }

    deinit {
        print("Deinit CategoryTabViewController")
    }

    func setTitles(categoryTabs: [CategoryTab],
                   distribution: ViewPagerOptions.Distribution = .equal,
                   swipeToScroll: Bool = true) {
        // Prevent first tab to reload
//        categoryTabs.first?.isLoaded = true

        // Set data
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

extension CategoryTabViewController: ViewPagerDataSource, ViewPagerDelegate {
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
        return firstSelectedIndex
    }
  
    func startViewPagerAtIndex(index: Int) -> Int {
        return index
    }

    func didMoveToControllerAtIndex(index: Int) {
        let tab = categoryTabs[index]
        tab.viewController.didShowViewController()
        didSelectTab?(index, tab.isLoaded)
        if !tab.isLoaded {
            tab.isLoaded = true
            tab.viewController.needsToLoadData(index: index)
        } else {
            tab.viewController.loadAlways(index: index)
        }
    }

    func willMoveToControllerAtIndex(index: Int) {
        let tab = categoryTabs[index]
        tab.viewController.preloadData(index: index)
    }
}

class CategoryTab {
    let tab: ViewPagerTab
    let viewController: PagerObserver
    var isLoaded: Bool

    init(title: String, viewController: PagerObserver) {
        self.tab = ViewPagerTab(title: title, image: nil)
        self.viewController = viewController
        self.isLoaded = false
    }
}

protocol PagerObserver where Self: UIViewController {
    /// Implement request data in this method.
    /// Only load data once, when user tap the tab for the first time.
    /// - Parameter index: index of tab to reload
    func needsToLoadData(index: Int)

    /// Implement request data in this method.
    /// Loads data whenever user change tab, regardless the data is requested or not.
    /// - Parameter index: index of tab to reload
    func loadAlways(index: Int)

    func preloadData(index: Int)
    func didShowViewController()
}

extension PagerObserver {
    func didShowViewController() {}
    func preloadData(index: Int) {}
    func loadAlways(index: Int) {}
}
