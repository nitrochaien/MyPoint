//
//  StoreDetailViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 3/25/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Lightbox

class StoreDetailViewController: BaseViewController,
    UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var headerContainerView: UIView!
  @IBOutlet weak var storeLogoImageView: UIImageView!
  @IBOutlet weak var storeNameLabel: UILabel!
  @IBOutlet weak var storeAddressLabel: UILabel!
  @IBOutlet weak var storePhoneLabel: UILabel!
  @IBOutlet weak var storeMapLinkButton: UIButton!
  
  @IBOutlet weak var imageCollectionContainerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var infoContainerView: UIView!
  @IBOutlet weak var infoContainerViewHeightConstraint: NSLayoutConstraint!
  
  var infoHeight: CGFloat = 0.0
  
  var storeId = ""
  
  private let presenter = StoreDetailPresenter()
  
  let underlineAttributes: [NSAttributedString.Key: Any] = [
  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
  NSAttributedString.Key.foregroundColor: UIColor(hexString: "#287EFF")!,
  NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeBackButton()
    hideKeyboardWhenTappedAround()
    configCollectionView()
    initView()
    presenter.delegate = self
    print("storeId: \(storeId)")
    presenter.getStoreDetail(storeId: storeId)
  }
  
  override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      UserDefaults.standard.set("", forKey: "comment")
      UserDefaults.standard.set(0, forKey: "rate")
      UserDefaults.standard.synchronize()
      NotificationCenter.default.addObserver(self, selector: #selector(submitReview),
                                             name: NotificationName.didSubmitReview,
                                             object: nil)
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
  }
  
  deinit {
      NotificationCenter.default.removeObserver(self)
      print("Deinit StoreDetailViewController")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  func initView() {
    self.title = "merchant.merchant_detail".localized
    infoContainerView.translatesAutoresizingMaskIntoConstraints = false
    let attributeString = NSMutableAttributedString(string: "Bản đồ".localized(),
    attributes: underlineAttributes)
    storeMapLinkButton.setAttributedTitle(attributeString, for: .normal)
  }
  
  func displayStore() {
    if let url = URL(string: presenter.store.logo ?? "") {
        self.storeLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
    } else {
       self.storeLogoImageView.image = UIImage(named: "alter")
    }
    storeNameLabel.text = presenter.store.name
    storeAddressLabel.text = presenter.store.address
    storePhoneLabel.text = presenter.store.phone
    
    let storyboard = UIStoryboard(name: "MerchantVoucher", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "MerchantVoucherViewController") as? MerchantVoucherViewController
    viewController?.delegate = self
    viewController?.brandId = "28"
    let storyboard3 = UIStoryboard(name: "StoreComment", bundle: nil)
    let viewController3 = storyboard3
        .instantiateViewController(withIdentifier: "StoreCommentViewController") as? StoreCommentViewController
    viewController3?.delegate = self
    viewController3?.storeId = storeId
//    viewController3?.brandId = "28"
    let tab = CategoryTabViewController()
    tab.navigationController?.navigationBar.isHidden = true
    tab.setTitles(categoryTabs: [
                CategoryTab(title: "merchant.store_voucher".localized,
                            viewController: viewController!),
               CategoryTab(title: "merchant.comment".localized,
                           viewController: viewController3!)
           ], distribution: .segmented, swipeToScroll: false)
    infoContainerView.addSubview(tab.view)
    tab.view.makeConstraintToFullWithParentView()
    addChild(tab)
    tab.didMove(toParent: self)
  }
  
  @objc func submitReview(notification: Notification) {
    guard let review = notification.object as? Review else { return }
    print("reviewwwwww: \(review)")
    presenter.submitComment(storeId: storeId, reviewContent: review.review ?? "", reviewRating: review.rate ?? "0")
    self.view.endEditing(true)
  }
  
  @IBAction func buttonStoreMapTapped(_ sender: Any) {
    guard let lat = presenter.store.latitude, let latDouble =  Double(lat) else { return }
    guard let long = presenter.store.longitude, let longDouble =  Double(long) else { return }
    if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {  // if phone has an app
        let urlString =      "comgooglemaps-x-callback://?center=\(latDouble),\(longDouble)&q=\(latDouble),\(longDouble)&zoom=14"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:])
        }
    } else {
        // Open in browser
        showGoogleMap(withLat: latDouble, long: longDouble)
    }
  }
  
  func display(height: CGFloat) {
    DispatchQueue.main.async {
      self.infoContainerViewHeightConstraint.constant = height
    }
  }
  
  func configCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    self.collectionView.register(UINib(nibName: "MerchantImageCell", bundle: nil), forCellWithReuseIdentifier: "MerchantImageCell")
  }
  
  func dequeueMerchantImageCell(indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantImageCell", for: indexPath) as? MerchantImageCell else {
      fatalError("Empty Cell")
    }
    if let url = URL(string: presenter.store.brand?.images?[indexPath.row].imageURL ?? "") {
        cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
    } else {
        cell.imageView.image = UIImage(named: "alter")
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.view.frame.size.width / 2.8, height: 80)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return presenter.store.brand?.images?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    dequeueMerchantImageCell(indexPath: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var lightBoxImages: [LightboxImage] = []
    for image in presenter.brandDetail.images ?? [] {
      if let url = URL(string: image.imageURL ?? "") {
        lightBoxImages.append(LightboxImage(imageURL: url))
      }
    }
    LightboxConfig.CloseButton.image = UIImage(named: "ic_close_white")
    LightboxConfig.CloseButton.text = ""
    let controller = LightboxController(images: lightBoxImages, startIndex: indexPath.row)
    controller.pageDelegate = self
    controller.dismissalDelegate = self
    controller.modalPresentationStyle = .fullScreen
    self.present(controller, animated: true, completion: nil)
  }
  
}

extension StoreDetailViewController: LightboxControllerPageDelegate {
  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    print(page)
  }
}

extension StoreDetailViewController: LightboxControllerDismissalDelegate {

  func lightboxControllerWillDismiss(_ controller: LightboxController) {
    // ...
  }
}

extension StoreDetailViewController: StoreDetailProtocols {
  func showError(message: String) {
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func display() {
    self.displayStore()
    self.collectionView.reloadData()
  }
  
}

extension StoreDetailViewController: DidLayoutMerchantVoucherProtocol {
  func updateMerchantVoucherLayout(size: CGSize) {
//    self.display(size: size)
  }
  
  func updateMerchantVoucherLayout(height: CGFloat) {
    self.display(height: height)
  }
}

extension StoreDetailViewController: DidLayoutMerchantNearbyStoreProtocol {
  func updateLayout(size: CGSize) {
  }
  
  func updateLayout(height: CGFloat) {
    self.display(height: height)
  }
}

extension StoreDetailViewController: DidLayoutStoreCommentProtocol {
  func updateStoreCommentLayout(height: CGFloat) {
    self.display(height: height)
  }
}
