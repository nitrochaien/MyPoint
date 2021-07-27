//
//  RatingViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class RatingViewController: UIViewController {

    @IBOutlet private weak var ratingView: CosmosView!
    @IBOutlet private weak var ratingDescriptionLabel: UILabel!
    @IBOutlet private weak var feedbackTextView: UITextView!
    @IBOutlet private weak var inputCounterLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!

    private let presenter = RatingPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        configFeedbackInput()
        configRatingStars()

        presenter.delegate = self

        registerForKeyboardNotifications()
    }

    func setId(_ id: String) {
        presenter.requestModel = .init(id: id)
    }

    @IBAction private func onTapDismiss(_ sender: Any) {
        navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NotificationName.dismissRating, object: nil)
    }

    private func configFeedbackInput() {
        feedbackTextView.borderColor = .lightGray
        feedbackTextView.borderWidth = 1
        feedbackTextView.cornerRadius = 8
        feedbackTextView.text = "voucher.feedback_placeholder".localized
        feedbackTextView.textColor = UIColor.lightGray
        feedbackTextView.delegate = self
        feedbackTextView.textContainerInset = .init(top: 12, left: 12, bottom: 12, right: 12)
    }

    private func configRatingStars() {
        ratingView.rating = 5
        ratingView.filledImage = UIImage(named: "ic_star_filled")
        ratingView.emptyImage = UIImage(named: "ic_star_empty")
        ratingView.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            let intValue = Int(rating)
            self.ratingDescriptionLabel.text = String(format: "rating.%d", intValue).localized
            self.presenter.requestModel?.stars = intValue
        }
    }
    
    @IBAction func onPressHelper(_ sender: Any) {
        showCustomAlert(withTitle: "Yay", andContent: "You called for help!")
    }
    
    @IBAction func onPressSendFeedback(_ sender: Any) {
        presenter.rateTransaction()
    }

    // MARK: Handle Keyboard Events
    deinit {
        print("Deinit RatingViewController")
        NotificationCenter.default.removeObserver(self)
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardAppear),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardDisappear),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tap)
    }

    @objc func onKeyboardAppear(_ notification: NSNotification) {
        let info = notification.userInfo
        guard let rect: CGRect = info?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let kbSize = rect.size

        let insets = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets

        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
        var aRect = scrollView.frame
        aRect.size.height -= kbSize.height

       if aRect.contains(feedbackTextView.frame.origin) {
            let scrollPoint = CGPoint(x: 0, y: 20)
            scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }

    @objc func onKeyboardDisappear(_ notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }

    @objc override func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension RatingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateCounter(with: textView.text.count)
        presenter.requestModel?.reviewContent = textView.text
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(hexString: "#032041")
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "voucher.feedback_placeholder".localized
            textView.textColor = UIColor.lightGray
        }
    }

    private func updateCounter(with value: Int) {
        let errorColor = UIColor(hexString: "#ED1B24")
        let normalColor = UIColor(hexString: "#4F4F4F")
        inputCounterLabel.textColor = value >= Defines.maxFeedbackInput ? errorColor : normalColor
        inputCounterLabel.text = String(format: "%d/%d", value, Defines.maxFeedbackInput)
    }
}

extension RatingViewController: BaseProtocols {
    func requestSuccess() {
        navigationController?.popToRootViewController(animated: false)
        NotificationCenter.default.post(name: NotificationName.dismissRating, object: nil)
    }
}
