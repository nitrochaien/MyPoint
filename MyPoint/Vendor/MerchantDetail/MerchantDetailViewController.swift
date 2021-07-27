//
//  MerchantDetailViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/20/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Lightbox

class MerchantDetailViewController: BaseViewController,
    UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
  
  @IBOutlet weak var headerContainerView: UIView!
  @IBOutlet weak var headerBrandImageView: UIImageView!
  @IBOutlet weak var headerBrandNameLabel: UILabel!
  @IBOutlet weak var headerPointLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var accumulatedPercent: UILabel!
  
  @IBOutlet weak var coverImageContainerView: UIView!
  @IBOutlet weak var coverImageView: UIImageView!
  
//  @IBOutlet weak var categoryBrandContainerView: UIView!
//  @IBOutlet weak var categoryContainerView: UIView!
//  @IBOutlet weak var categoryImageView: UIImageView!
//  @IBOutlet weak var categoryHeaderLabel: UILabel!
//  @IBOutlet weak var categoryLabel: UILabel!
  
//  @IBOutlet weak var brandContainerView: UIView!
//  @IBOutlet weak var brandImageView: UIImageView!
//  @IBOutlet weak var brandWebsiteHeaderLabel: UILabel!
//  @IBOutlet weak var brandWebsiteLabel: UILabel!
  
  @IBOutlet weak var imageCollectionContainerView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  @IBOutlet weak var infoContainerView: UIView!
  @IBOutlet weak var infoContainerViewHeightConstraint: NSLayoutConstraint!
  
  var infoHeight: CGFloat = 0.0
  
  var brandId = ""
  
  private var likeId = ""
  
  private var liked: Bool = false
  
  private let presenter = MerchantDetailPresenter()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeBackButton()
    configCollectionView()
    customizeRightBarButton(liked: self.liked)
    initView()
    presenter.delegate = self
    presenter.getBrandDetail(brandId: brandId)
  }
  
  override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }
  
  func customizeRightBarButton(liked: Bool) {
    self.liked = liked
    if liked {
      let favourite = UIBarButtonItem(image: UIImage(named: "Loved"), style: .plain, target: self, action: #selector(tappedOnFavourite))
      favourite.tintColor = UIColor(hexString: "#fc1500")
      self.navigationItem.rightBarButtonItem  = favourite
    } else {
      let favourite = UIBarButtonItem(image: UIImage(named: "WhiteHeart"), style: .plain, target: self, action: #selector(tappedOnFavourite))
      favourite.tintColor = UIColor(hexString: "#032041")
      self.navigationItem.rightBarButtonItem  = favourite
    }
  }
  
  @objc private func tappedOnFavourite() {
    if !self.liked {
      presenter.likeBrand(brandId: brandId)
    } else {
      presenter.unLikeBrand(likeId: likeId)
    }
  }
  
  func initView() {
//    categoryHeaderLabel.text = "merchant.category".localized
//    brandWebsiteHeaderLabel.text = "merchant.website".localized
    self.title = "merchant.merchant_detail".localized
    infoContainerView.translatesAutoresizingMaskIntoConstraints = false
//    let storyboard1 = UIStoryboard(name: "MerchantInfo", bundle: nil)
//    let viewController1 = storyboard1.instantiateViewController(withIdentifier: "MerchantInfoViewController") as? MerchantInfoViewController
//    viewController1?.delegate = self
//    viewController1?.brandId = self.brandId
//    let viewController1 = NewMerchantInfoViewController()
//    viewController1.pageDetail = presenter.brandDetail.pageAbout
//    let storyboard2 = UIStoryboard(name: "MerchantVoucher", bundle: nil)
//    let viewController2 = storyboard2.instantiateViewController(withIdentifier: "MerchantVoucherViewController") as? MerchantVoucherViewController
//    viewController2?.delegate = self
//    viewController2?.brandId = self.brandId
//    let storyboard3 = UIStoryboard(name: "MerchantNearbyStore", bundle: nil)
//    let viewController3 = storyboard3
//        .instantiateViewController(withIdentifier: "MerchantNearbyStoreViewController") as? MerchantNearbyStoreViewController
//    viewController3?.delegate = self
//    viewController3?.brandId = self.brandId
//    let tab = CategoryTabViewController()
//    tab.navigationController?.navigationBar.isHidden = true
//    tab.setTitles(categoryTabs: [
//                CategoryTab(title: "merchant.voucher".localized,
//                            viewController: viewController2!),
//               CategoryTab(title: "merchant.info".localized,
//                           viewController: viewController1),
//               CategoryTab(title: "merchant.store".localized,
//                           viewController: viewController3!)
//           ], distribution: .segmented, swipeToScroll: false)
//    infoContainerView.addSubview(tab.view)
//    tab.view.makeConstraintToFullWithParentView()
//    addChild(tab)
//    tab.didMove(toParent: self)
  }
  
  func configCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    self.collectionView.register(UINib(nibName: "MerchantImageCell", bundle: nil), forCellWithReuseIdentifier: "MerchantImageCell")
  }
  
  func display(size: CGSize) {
    DispatchQueue.main.async {
      self.infoContainerViewHeightConstraint.constant = size.height + 80.0
    }
  }
  
  func display(height: CGFloat) {
    DispatchQueue.main.async {
      self.infoContainerViewHeightConstraint.constant = height
    }
  }
  
  func display(brandDetail: BrandDetail) {
    DispatchQueue.main.async {
      if let url = URL(string: brandDetail.logo ?? "") {
        self.headerBrandImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
      } else {
        self.headerBrandImageView.image = UIImage(named: "alter")
      }
      
      self.headerBrandNameLabel.text = brandDetail.brandName ?? ""
      
      self.headerPointLabel.text = "merchant.point_accumulation_rate".localized
      self.accumulatedPercent.text = (brandDetail.displayPointAccumulationRate ?? "") + "%"
//
        self.categoryLabel.text = brandDetail.category?.categoryName ?? ""
//
//      self.brandWebsiteLabel.text = brandDetail.website ?? ""
      
        if let url = URL(string: brandDetail.coverImages.first?.imageURL ?? "") {
         self.coverImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
       } else {
          self.coverImageContainerView.isHidden = true
       }
      
        if let likeId = brandDetail.likeId, likeId != "" {
          self.likeId = likeId
          self.customizeRightBarButton(liked: true)
        } else {
          self.customizeRightBarButton(liked: false)
        }
    }
    
  }
  
  func dequeueMerchantImageCell(indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MerchantImageCell", for: indexPath) as? MerchantImageCell else {
      fatalError("Empty Cell")
    }
    if let url = URL(string: presenter.brandDetail.backgroundImages[indexPath.row].imageURL ?? "") {
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
    return presenter.brandDetail.backgroundImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    dequeueMerchantImageCell(indexPath: indexPath)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    var lightBoxImages: [LightboxImage] = []
    for image in presenter.brandDetail.backgroundImages {
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

extension MerchantDetailViewController: LightboxControllerPageDelegate {
  func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    print(page)
  }
}

extension MerchantDetailViewController: LightboxControllerDismissalDelegate {

  func lightboxControllerWillDismiss(_ controller: LightboxController) {
    // ...
  }
}

extension MerchantDetailViewController: DidLayoutMerchantNearbyStoreProtocol {
  func updateLayout(size: CGSize) {
//    print("size: \(size.height)")
    self.display(size: size)
  }
  
  func updateLayout(height: CGFloat) {
    self.display(height: height)
  }
}

extension MerchantDetailViewController: DidLayoutMerchantVoucherProtocol {
  func updateMerchantVoucherLayout(size: CGSize) {
//    self.display(size: size)
  }
  
  func updateMerchantVoucherLayout(height: CGFloat) {
    self.display(height: height)
  }
}

extension MerchantDetailViewController: DidLayoutMerchantInfoProtocol {
  func updateInfoLayout(height: CGFloat) {
    self.display(height: height)
  }
  
  func updateInfoLayout(size: CGSize) {
    self.display(size: size)
  }
}

extension MerchantDetailViewController: MerchantDetailProtocols {
  func showListStoreByBrand() {
    
  }
  
  func showListVoucherByBrand() {
    
  }
  
  func showError(message: String) {
    self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
  }
  
  func display(brand: BrandDetail) {
    self.display(brandDetail: brand)
    let viewController1 = NewMerchantInfoViewController()
    viewController1.pageDetail = presenter.brandDetail.pageAbout ?? Page()
    viewController1.delegate = self
    let storyboard2 = UIStoryboard(name: "MerchantVoucher", bundle: nil)
    let viewController2 = storyboard2.instantiateViewController(withIdentifier: "MerchantVoucherViewController") as? MerchantVoucherViewController
    viewController2?.delegate = self
    viewController2?.brandId = self.brandId
    let storyboard3 = UIStoryboard(name: "MerchantNearbyStore", bundle: nil)
    let viewController3 = storyboard3
        .instantiateViewController(withIdentifier: "MerchantNearbyStoreViewController") as? MerchantNearbyStoreViewController
    viewController3?.delegate = self
    viewController3?.brandId = self.brandId
    let tab = CategoryTabViewController()
    tab.navigationController?.navigationBar.isHidden = true
    tab.setTitles(categoryTabs: [
                CategoryTab(title: "merchant.voucher".localized,
                            viewController: viewController2!),
               CategoryTab(title: "merchant.store".localized,
                           viewController: viewController3!),
               CategoryTab(title: "merchant.info".localized,
               viewController: viewController1)
           ], distribution: .segmented, swipeToScroll: false)
    infoContainerView.addSubview(tab.view)
    tab.view.makeConstraintToFullWithParentView()
    addChild(tab)
    tab.didMove(toParent: self)
    if presenter.brandDetail.backgroundImages.isEmpty {
      imageCollectionContainerView.isHidden = true
    }
    self.collectionView.reloadData()
  }
  
  func didLikeBrand() {
    self.liked = true
    presenter.getBrandDetail(brandId: brandId)
    customizeRightBarButton(liked: self.liked)
  }
  
  func didUnlikeBrand() {
    self.liked = false
    self.likeId = ""
    presenter.getBrandDetail(brandId: brandId)
    customizeRightBarButton(liked: self.liked)
  }
  
}
