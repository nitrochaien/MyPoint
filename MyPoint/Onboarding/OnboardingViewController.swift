//
//  OnboardingViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 12/28/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

final class OnboardingViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var indicatorView: UIImageView!
    @IBOutlet private weak var nextButtonLeading: NSLayoutConstraint!
    @IBOutlet private weak var nextButton: ProceedButton!
    @IBOutlet private weak var skipButton: UIButton!
    
    private let presenter = OnboardingPresenter()

    private let maxLeading: CGFloat = 96
    private let minLeading: CGFloat = 28
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)

        presenter.delegate = self
        nextButton.activeState = .active
        nextButton.isHighlighted = false

        configCollectionView()
        updateUI(at: 0)
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: OnboardingCollectionViewCell.identifier)
        collectionView.collectionViewLayout = OnboardingFlowLayout()
    }

    private func hideBackButton() {
        if backButton.isHidden { return }

        nextButtonLeading.constant = minLeading
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { completed in
            if completed {
                UIView.animate(withDuration: 0.2) {
                    self.backButton.isHidden = true
                }
            }
        }
    }

    private func showBackButton() {
        if !backButton.isHidden { return }

        nextButtonLeading.constant = maxLeading
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { completed in
            if completed {
                self.backButton.isHidden = false
            }
        }
    }

    @IBAction private func onNext(_ sender: Any) {
        if nextButton.activeState == .proceed {
            navigateToNextScreen()
        } else {
            presenter.handleNext()
        }
    }

    @IBAction private func onBack(_ sender: Any) {
        presenter.handleBack()
    }

    @IBAction private func onSkip(_ sender: Any) {
        navigateToNextScreen()
    }

    func navigateToNextScreen() {
        setRoot(storyboard: "Authenciation", viewControllerId: "RegisterViewController")
    }

    fileprivate func updateUI(at index: Int) {
        guard let item = presenter.data[safe: index] else { return }
        
        indicatorView.image = UIImage(named: item.indicator)
        collectionView.scrollToItem(at: IndexPath(row: index, section: 0),
                                    at: .left,
                                    animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let flowLayout = collectionView.collectionViewLayout as? OnboardingFlowLayout {
            flowLayout.config()
        }
    }
}

extension OnboardingViewController: OnboardingProtocols {
    func didSelectItem(at index: Int) {
        updateUI(at: index)

        switch index {
        case 0:
            if nextButton.activeState != .active {
                nextButton.setTitle("common.continue".localized, for: .normal)
                nextButton.activeState = .active
            }
            skipButton.isHidden = false
            hideBackButton()
        case 1:
            if nextButton.activeState != .active {
                nextButton.setTitle("common.continue".localized, for: .normal)
                nextButton.activeState = .active
            }
            skipButton.isHidden = false
            showBackButton()
        case 2:
            nextButton.setTitle("onboarding.begin".localized, for: .normal)
            if nextButton.activeState != .proceed {
                nextButton.activeState = .proceed
            }
            skipButton.isHidden = true
            showBackButton()
        default:
            break
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = collectionView.contentOffset.x
        let w = collectionView.bounds.size.width
        presenter.index = Int(ceil(x/w))
        if 0...presenter.data.count-1 ~= presenter.index {
            didSelectItem(at: presenter.index)
        }
    }
}

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: OnboardingCollectionViewCell.identifier,
                                 for: indexPath) as? OnboardingCollectionViewCell {
            let data = presenter.data[indexPath.row]
            cell.setData(data: data)

            return cell
        }
        return UICollectionViewCell()
    }
}
