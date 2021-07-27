//
//  CardDetailViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 11/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol CardDetailViewControllerDelegate: NSObjectProtocol {
    func cardDetailViewController(_ vc: CardDetailViewController,
                                  onChange useStatus: Bool,
                                  id: ProductId)
}

final class CardDetailViewController: UIViewController {

    @IBOutlet private weak var detailView: CardDetailView!
    @IBOutlet private weak var payNowButton: UIButton!

    private var patternVC: ChangeCardPatternViewController!

    private let presenter = CardDetailPresenter()

    weak var delegate: CardDetailViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeBackButton()
        title = "voucher.card_detail".localized

        detailView.onChangeCardStatus = { [weak self] used in
            guard let self = self else { return }
            self.delegate?.cardDetailViewController(self,
                                                    onChange: used,
                                                    id: self.presenter.id)
            self.setButtonStatus(used: used)
        }

        presenter.delegate = self
        presenter.getDetail()
    }

    func setValue(_ id: ProductId) {
        presenter.id = id
    }

    @IBAction private func didTapPayNow(_ sender: Any) {
        showPatternView()
    }

    private func showPatternView() {
        patternVC = ChangeCardPatternViewController()
        patternVC.codes = [
            .init(title: "voucher.pre_paid_pattern".localized,
                  content: String(format: TelcoPattern.prePaid,
                                  presenter.card.code)),
            .init(title: "voucher.post_paid_pattern".localized,
                  content: String(format: TelcoPattern.postPaidViettel,
                                  presenter.card.code))
        ]
        patternVC.didHideSelection = { [weak self] in
            self?.patternVC = nil
        }
        addChild(patternVC)
        patternVC.view.frame = view.frame
        view.addSubview(patternVC.view)
        patternVC.didMove(toParent: self)
    }
}

extension CardDetailViewController: CardDetailDelegate {
    func display(_ card: CardDetailPresenter.Card) {
        detailView.setData(card)
        setButtonStatus(used: card.used)
    }

    func setButtonStatus(used: Bool) {
        if used {
            setInactiveButton()
        } else {
            setActiveButton()
        }
    }

    private func setActiveButton() {
        payNowButton.setBackgroundImage(UIImage(named: "btn_next_background"), for: .normal)
        payNowButton.backgroundColor = .clear
        payNowButton.isUserInteractionEnabled = true
    }

    private func setInactiveButton() {
        payNowButton.backgroundColor = #colorLiteral(red: 0.5725490196, green: 0.5764705882, blue: 0.662745098, alpha: 0.5)
        payNowButton.setBackgroundImage(nil, for: .normal)
        payNowButton.isUserInteractionEnabled = false
    }

    func requestSuccess() {}
}
