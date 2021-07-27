//
//  AddCommentView.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/15/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Cosmos

protocol AddCommentTextViewDidChangeProtocol: NSObjectProtocol {
  func addCommentTextViewDidChange(comment: String)
  
  func didChangeRating(rate: Double)
}

final class AddCommentView: UIView {
  
  @IBOutlet var containerView: UIView!
  @IBOutlet weak var ratingView: CosmosView!
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var sendButton: UIButton!
  private var rate: Double = 0
  private var reviewContent = ""
  
  weak var delegate: AddCommentTextViewDidChangeProtocol?
  
  override init(frame: CGRect) {
      super.init(frame: frame)
      commonInit()
  }
  
  required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      commonInit()
  }
  
  func commonInit() {
    Bundle.main.loadNibNamed("AddCommentView", owner: self, options: nil)
    guard let content = containerView else { return }
    content.frame = self.bounds
    content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(content)
    
    let storage = Storage.shared
    let userData = storage.loginData
    if let localImage = storage.localUserProfilePic {
      avatarImageView.image = localImage
    } else {
      avatarImageView.image = userData?.workerSite?.image
    }
    commentTextView.delegate = self
    commentTextView.text = UserDefaults.standard.string(forKey: "comment") ?? ""
    ratingView.rating = UserDefaults.standard.double(forKey: "rate")
    self.rate = UserDefaults.standard.double(forKey: "rate")
    self.reviewContent = UserDefaults.standard.string(forKey: "comment") ?? ""
    enableSendButton()
    ratingView.settings.fillMode = .full
    ratingView.settings.minTouchRating = 1.0
    ratingView.settings.updateOnTouch = true
    ratingView.prepareForReuse()
    ratingView.didFinishTouchingCosmos = { rating in
      self.ratingView.rating = rating
      self.rate = rating
      self.delegate?.didChangeRating(rate: rating)
      self.enableSendButton()
      UserDefaults.standard.set(rating, forKey: "rate")
      UserDefaults.standard.synchronize()
      print("rate: \(rating)")
    }
  }
  
  override func didMoveToWindow() {
    commentTextView.becomeFirstResponder()
  }
  
  @IBAction func sendButtonTapped(_ sender: Any) {
    print("sent: \(rate) + \(commentTextView.text ?? "") ")
    let review = Review(rate: rate, review: commentTextView.text)
    commentTextView.resignFirstResponder()
    NotificationCenter.default.post(name: NotificationName.didSubmitReview, object: review)
  }
  
  func enableSendButton() {
    DispatchQueue.main.async {
      if self.rate != 0 && self.reviewContent.count > 30 {
        self.sendButton.isEnabled = true
      } else {
        self.sendButton.isEnabled = false
      }
    }
  }
}

extension AddCommentView: UITextViewDelegate {
  func textViewDidChange(_ textView: UITextView) {
    self.delegate?.addCommentTextViewDidChange(comment: textView.text)
    self.reviewContent = textView.text
    self.enableSendButton()
    UserDefaults.standard.set(textView.text, forKey: "comment")
    UserDefaults.standard.synchronize()
  }
}
