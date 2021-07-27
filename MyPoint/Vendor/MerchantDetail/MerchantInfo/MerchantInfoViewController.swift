//
//  MerchantInfoViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/21/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol DidLayoutMerchantInfoProtocol: NSObjectProtocol {
    func updateInfoLayout(size: CGSize)
  
    func updateInfoLayout(height: CGFloat)
}

class MerchantInfoViewController: UIViewController, PagerObserver {
  
  @IBOutlet weak var scrollView: UIScrollView!
  
  @IBOutlet weak var infoImageContainerView: UIView!
  @IBOutlet weak var infoImageView: UIImageView!
  
  @IBOutlet weak var infoHeaderContainerView: UIView!
  @IBOutlet weak var infoHeaderLabel: UILabel!
  
  @IBOutlet weak var infoDescriptionContainerView: UIView!
  @IBOutlet weak var infoDescriptionLabel: UILabel!
  
  @IBOutlet weak var infoCommentHeaderContainerView: UIView!
  @IBOutlet weak var infoCommentHeaderLabel: UILabel!
  
  @IBOutlet weak var infoSelfDesContainerView: UIView!
  @IBOutlet weak var infoSelfDescLabel: UILabel!
  
  var brandId = ""
  
  private let presenter = MerchantDetailPresenter()
  
  weak var delegate: DidLayoutMerchantInfoProtocol?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      delegate?.updateInfoLayout(size: scrollView.frame.size)
  }
  
  func needsToLoadData(index: Int) {
    
  }
}
