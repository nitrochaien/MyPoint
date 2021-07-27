//
//  InterestedCategoriesViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class InterestedCategoriesViewController: UIViewController {

    @IBOutlet private weak var confirmButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    private let itemNibName = "InterestedItemCollectionViewCell"
    private let headerNibName = "InterestedItemHeaderCollectionViewCell"
    private let presenter = InterestedCategoriesPresenter()

    private enum SectionType: Int, CaseIterable {
        case header = 0, item
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        presenter.delegate = self
        presenter.requestCategoryList()

        deactiveNextButton()
        configCollectionView()
    }

    private func activeNextButton() {
        confirmButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
        confirmButton.backgroundColor = .clear
        confirmButton.isUserInteractionEnabled = true
    }

    private func deactiveNextButton() {
        confirmButton.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.5764705882, blue: 0.662745098, alpha: 0.5)
        confirmButton.setBackgroundImage(nil, for: .normal)
        confirmButton.isUserInteractionEnabled = false
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib(nibName: itemNibName,
                                      bundle: nil),
                                forCellWithReuseIdentifier: itemNibName)
        collectionView.register(UINib(nibName: headerNibName,
                                      bundle: nil),
                                forCellWithReuseIdentifier: headerNibName)
        collectionView.collectionViewLayout = FlowLayout()
    }

    @IBAction func onSkip(_ sender: Any) {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NotificationName.didChangeInterestedCategories, object: nil)
        }
    }

    @IBAction func onConfirm(_ sender: Any) {
        presenter.submitSelectedItems()
    }
}

extension InterestedCategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SectionType.header.rawValue:
            return collectionView.dequeueReusableCell(withReuseIdentifier: headerNibName,
                                                      for: indexPath)
        case SectionType.item.rawValue:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemNibName,
                                                             for: indexPath) as? InterestedItemCollectionViewCell {
                cell.setData(presenter.categories[indexPath.row])
                return cell
            }
        default:
            return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case SectionType.header.rawValue:
            return 0
        case SectionType.item.rawValue:
            return presenter.categories.count
        default:
            return 0
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SectionType.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.categories[indexPath.row].isSelected.toggle()

        if presenter.allowsToProceed {
            activeNextButton()
        }

        collectionView.reloadData()
    }
}

extension InterestedCategoriesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        switch indexPath.section {
        case SectionType.header.rawValue:
            return .init(width: screenWidth, height: 200)
        case SectionType.item.rawValue:
            return .init(width: (screenWidth - 48) / 2, height: 104)
        default:
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case SectionType.item.rawValue:
            return .init(top: 8, left: 16, bottom: 8, right: 16)
        default:
            return .zero
        }
    }
}

extension InterestedCategoriesViewController: InterestedCategoriesPresenterDelegate {
    func didSubmitSelectedItems() {
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NotificationName.didChangeInterestedCategories, object: nil)
        }
    }

    func requestSuccess() {
        collectionView.reloadData()
    }
}

private class FlowLayout: UICollectionViewFlowLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
