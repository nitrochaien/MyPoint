//
//  CheckInViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 2/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CheckInViewController: BaseViewController {

    @IBOutlet private weak var pointLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var checkInButton: UIButton!
    
    private let presenter = CheckInPresenter()
    private let cellId = "CheckInCollectionViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = "check-in.title".localized

        customizeBackButton()
        configCollectionView()
        checkInButton.isHidden = true

        presenter.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if showFirstTime {
            presenter.getItems()
        }
    }

    deinit {
        print("Deinit CheckInViewController")
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cellId,
                                      bundle: nil),
                                forCellWithReuseIdentifier: cellId)
    }

    private func showMyPoints() {
        let pointString = presenter.points.formattedWithSeparator
        let descriptionText = String(format: "check-in.my_point_format".localized,
                                     pointString)
        let attribute = pointLabel.getAttributeSpacing(inputText: descriptionText, lineSpacing: 8.0)
        let maxRange = NSRange(location: 0, length: descriptionText.count)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#032041")!],
                                 range: maxRange)

        let hightlightedRange = (descriptionText as NSString).range(of: pointString)
        attribute?.addAttributes([.font: UIFont.systemFont(ofSize: 16, weight: .medium),
                                  .foregroundColor: UIColor(hexString: "#1556FC")!],
                                 range: hightlightedRange)

        pointLabel.attributedText = attribute
    }
    
    @IBAction private func onTapCheckIn(_ sender: Any) {
        presenter.checkIn()
    }

    private func disableButton() {
        checkInButton.setBackgroundImage(nil, for: .normal)
        checkInButton.backgroundColor = UIColor(hexString: "#98A1AF")
        checkInButton.setTitle("check-in.comeback".localized, for: .normal)
        checkInButton.isUserInteractionEnabled = false
    }

    fileprivate func showSuccessScreen() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let contentViewController = CheckinSuccessViewController()
        contentViewController.points = String(format: "%.0f", presenter.rewardValue)
        contentViewController.didConfirm = {

        }
        alertController.setValue(contentViewController, forKey: "contentViewController")
        present(alertController, animated: true, completion: nil)
    }
}

extension CheckInViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? CheckInCollectionViewCell {
            cell.setData(presenter.items[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.items.count
    }
}

extension CheckInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 8
        let width = (UIScreen.main.bounds.width - (spacing * 8)) / 7
        return .init(width: max(50, width), height: 70)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension CheckInViewController: BaseProtocols {
    func requestSuccess() {
        showMyPoints()
        collectionView.reloadData()

        if presenter.didCheckInToday {
            disableButton()

            if presenter.needsToTriggerAlert {
                showSuccessScreen()
            }
        }
        checkInButton.isHidden = false
    }
}
