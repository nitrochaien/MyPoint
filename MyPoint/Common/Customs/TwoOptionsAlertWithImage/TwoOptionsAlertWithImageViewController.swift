//
//  TwoOptionsAlertWithImageViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class TwoOptionsAlertWithImageViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var headerLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var topButton: UIButton!
  @IBOutlet weak var bottomButton: UIButton!
  
  var handlePressTopButton: (() -> Void)?
  var handlePressBottomButton: (() -> Void)?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bottomButton.layer.borderWidth = 1
    bottomButton.layer.borderColor = UIColor(hexString: "727C88")?.cgColor
  }
  
  func updateData(information: NSMutableAttributedString, with model: TwoOptionsButtonWithImage) {
    headerLabel.text = model.title
    imageView.image = model.image
    //        contentLabel.attributedText = model.content
    contentLabel.attributedText = information
    topButton.setTitle(model.topButtonTitle, for: .normal)
    bottomButton.setTitle(model.bottomButtonTitle, for: .normal)
    switch model.type {
    case .normal:
      topButton.setBackgroundImage(UIImage(named: "btn_continue_background"), for: .normal)
      topButton.backgroundColor = .clear
    case .destructive:
      topButton.setBackgroundImage(nil, for: .normal)
      topButton.backgroundColor = UIColor(hexString: "#E71D28")
    case .confirm:
      topButton.setBackgroundImage(nil, for: .normal)
      topButton.backgroundColor = UIColor(hexString: "#17AC65")
    }
  }
  
  @IBAction func topButtonTapped(_ sender: Any) {
    dismiss(animated: true) { [weak self] in
        self?.handlePressTopButton?()
    }
  }
  
  @IBAction func bottomButtonTapped(_ sender: Any) {
    dismiss(animated: true) { [weak self] in
        self?.handlePressBottomButton?()
    }
  }
  
}
