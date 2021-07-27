//
//  QRCodePagerViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/24/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class QRCodePagerViewController: UIPageViewController {

    fileprivate var orderedViewControllers: [UIViewController] = {
        let vc1 = ScannerViewController(nibName: "ScannerViewController", bundle: nil)
        let vc2 = QRCardViewController(nibName: "QRCardViewController", bundle: nil)

        return [vc1, vc2]
    }()

    private var selectedIndex = 0

    var onChangedTab: ((_ index: Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            onChangedTab?(selectedIndex)
        }
    }

    func forwardToUseCard() {
        if selectedIndex == 1 { return }

        let vc = orderedViewControllers[1]
        setViewControllers([vc],
                           direction: .forward,
                           animated: true,
                           completion: nil)
        selectedIndex = 1
        onChangedTab?(selectedIndex)
    }

    func backToScanner() {
        if selectedIndex == 0 { return }

        let vc = orderedViewControllers[0]
        setViewControllers([vc],
                           direction: .reverse,
                           animated: true,
                           completion: nil)
        selectedIndex = 0
        onChangedTab?(selectedIndex)
    }
}

extension QRCodePagerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let isScanner = previousViewControllers[0] is ScannerViewController
        onChangedTab?(isScanner ? 1 : 0)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCurrentIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerCurrentIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerCurrentIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerCurrentIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
}
