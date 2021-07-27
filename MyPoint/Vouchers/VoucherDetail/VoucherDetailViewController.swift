//
//  VoucherDetailViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 1/17/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MessageUI

final class VoucherDetailViewController: BaseViewController {

    // image
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    //  @IBOutlet weak var favouriteImageView: UIImageView!
    @IBOutlet weak var favouriteButton: UIButton!

    // title
    @IBOutlet weak var titleContainerView: UIView!
    @IBOutlet weak var voucherTitleLabel: UILabel!

    // price
    @IBOutlet weak var priceContainerView: UIView!
    @IBOutlet weak var voucherPriceLabel: UILabel!

    // expire
    @IBOutlet weak var expireContainerView: UIView!
    @IBOutlet weak var expireHeaderLabel: UILabel!
    @IBOutlet weak var expireDateLabel: UILabel!
    @IBOutlet weak var remainingTimeView: UIView!
    @IBOutlet weak var remainingLabel: UILabel!

    // detail
    @IBOutlet weak var detailContainerView: UIView!
    @IBOutlet weak var detailHeaderLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var detailTextViewHeightConstraint: NSLayoutConstraint?

    // condition
    @IBOutlet weak var conditionContainerView: UIView!
    @IBOutlet weak var conditionHeaderLabel: UILabel!
    @IBOutlet weak var conditionTextView: UITextView!
    @IBOutlet weak var conditionTextViewHeightConstraint: NSLayoutConstraint?

    // applicablePlace
    @IBOutlet weak var applicablePlaceContainerView: UIView!
    @IBOutlet weak var applicablePlaceHeaderLabel: UILabel!
    @IBOutlet weak var applicablePlaceTableView: UITableView!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var applicablePlaceTableViewHeightConnstrant: NSLayoutConstraint!
    
    // support
    @IBOutlet weak var supportContainerView: UIView!
    @IBOutlet weak var supportHeaderLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet weak var supportTableView: UITableView!
    @IBOutlet weak var supportTableViewHeightConstraint: NSLayoutConstraint!
    
    //usage
    @IBOutlet weak var useVoucherContainerView: UIView!
    @IBOutlet weak var useVoucherButton: UIButton!

    @IBOutlet weak var backButton: UIButton!

    var detailHeight: CGFloat = 0.0
    var conditionHeight: CGFloat = 0.0
    var applicablePlaces = 4
    private var isExpanded = false

    var voucherId: String = ""
    var voucherBrand: Brand?
    var listVoucherPlaces: [StoreList]?
    var readyToUse = false
    var isUsable = true
    private var brandName = ""
    private var brandMobile = ""
    private var brandEmail = ""
    private var redeemedVoucherId: String?
    private var codeSecret: String?
    private var voucherName = ""
    private var voucherDetail: VoucherDetail?

    private var likeId = ""

    private var liked: Bool = false

    private var locationObserver: NSKeyValueObservation?

    private var position: CLLocationCoordinate2D!
    
    private let presenter = VoucherDetailPresenter()

    let locationManager = CurrentLocationManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        //      display()
        configTableView()
        initView()
        self.presenter.delegate = self
        locationManager.delegate = self

        if !locationManager.isDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if !locationManager.canGetLocation {
            self.presenter.getVoucherApplicablePlace(voucherId: self.voucherId, lat: "1", long: "1")
            //        self.showTwoButtonsAlert(with: .cantGetLocationAlert, leftButtonCompletion: {
            //          [weak self] in self?.presenter.getVoucherApplicablePlace(voucherId: self?.voucherId ?? "", lat: "1", long: "1")
            //          }, rightButtonCompletion: {
            //          guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            //          if UIApplication.shared.canOpenURL(settingsUrl) {
            //              UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            //                  print("Settings opened: \(success)")
            //              })
            //          }
            //        })
        } else {
            print("request location 1st time")
            //        CurrentLocationManager.shared.requestLocation()
        }
        self.applicablePlaceTableView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
        self.supportTableView.addObserver(self, forKeyPath: "contentSize", options: [], context: nil)
    }

    func getListApplicablePlaces(voucherId: String) {
        if !locationManager.isDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if !locationManager.canGetLocation {
            self.presenter.getVoucherApplicablePlace(voucherId: self.voucherId, lat: "1", long: "1")
            //        self.showTwoButtonsAlert(with: .cantGetLocationAlert, leftButtonCompletion: {
            //          [weak self] in self?.presenter.getVoucherApplicablePlace(voucherId: self?.voucherId ?? "", lat: "1", long: "1")
            //          }, rightButtonCompletion: {
            //          guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            //          if UIApplication.shared.canOpenURL(settingsUrl) {
            //              UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            //                  print("Settings opened: \(success)")
            //              })
            //          }
            //        })
        } else {
            print("request location 1st time")
            locationManager.requestLocation()
        }
    }


    @IBAction func favouriteButtonTapped(_ sender: Any) {
        print("tapped")
        if !self.liked {
            presenter.likeVoucher(voucherId: voucherId)
        } else {
            presenter.unLikeVoucher(likeId: likeId)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(applicationDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    @objc func applicationDidBecomeActive() {
        locationManager.delegate = self
        if !locationManager.isDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if !locationManager.canGetLocation {
            self.presenter.getVoucherApplicablePlace(voucherId: self.voucherId, lat: "1", long: "1")
            //            self.showTwoButtonsAlert(with: .cantGetLocationAlert, leftButtonCompletion: {
            //              [weak self] in self?.presenter.getVoucherApplicablePlace(voucherId: self?.voucherId ?? "", lat: "1", long: "1")
            //              }, rightButtonCompletion: {
            //              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            //              if UIApplication.shared.canOpenURL(settingsUrl) {
            //                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
            //                      print("Settings opened: \(success)")
            //                  })
            //              }
            //            })
        } else {
            print("request location")
            //            CurrentLocationManager.shared.requestLocation()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if showFirstTime {
            if readyToUse {
                self.presenter.getUsableVoucherDetail(voucherId: voucherId)
                self.remainingTimeView.isHidden = false
            } else {
                self.presenter.getVoucherDetail(voucherId: voucherId)
                //            self.remainingTimeView.isHidden = true
            }
        }
        applicablePlaceTableView.frame = CGRect(x: applicablePlaceTableView.frame.origin.x,
                                                y: applicablePlaceTableView.frame.origin.y,
                                                width: applicablePlaceTableView.frame.size.width,
                                                height: applicablePlaceTableView.contentSize.height)
//        supportTableView.frame = CGRect(x: supportTableView.frame.origin.x,
//                                        y: supportTableView.frame.origin.y,
//                                        width: supportTableView.frame.size.width,
//                                        height: supportTableView.contentSize.height)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    func initView() {
        //      logoImageView.makeRoundedImage()
        voucherPriceLabel.textColor = UIColor(hexString: "#636363")
        expireHeaderLabel.text = "voucher.expireHeader".localized
        expireHeaderLabel.textColor = UIColor(hexString: "#727C88")
        detailHeaderLabel.text = "voucher.detailHeaderLabel".localized
        conditionHeaderLabel.text = "voucher.detailHeader".localized
        applicablePlaceHeaderLabel.text = "voucher.applicablePlaceHeader".localized
        //      favouriteImageView.image = UIImage(named: "Loved")
        if readyToUse {
            useVoucherButton.setTitle("common.use".localized, for: .normal)
            useVoucherButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
            useVoucherButton.backgroundColor = UIColor(hexString: "#21C777")
        } else {
            useVoucherButton.setTitle("voucher.exchange_voucher".localized, for: .normal)
            useVoucherButton.backgroundColor = UIColor(hexString: "#1556FC")
            useVoucherButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        }
        seeMoreButton.setTitle("voucher.see_more".localized, for: .normal)
        seeMoreButton.isEnabled = false
        seeMoreButton.isHidden = true
        customizeLikeButton(liked: self.liked)
        if isUsable {
            useVoucherContainerView.isHidden = false
        } else {
            useVoucherContainerView.isHidden = true
        }
    }

    func customizeLikeButton(liked: Bool) {
        //    self.liked = liked
        if liked {
            favouriteButton.setImage(UIImage(named: "Loved"), for: .normal)
            favouriteButton.tintColor = UIColor(hexString: "#fc1500")
            //      favouriteImageView.image = UIImage(named: "Loved")
        } else {
            favouriteButton.setImage(UIImage(named: "Loved_white"), for: .normal)
            favouriteButton.tintColor = UIColor(hexString: "#ffffff")
            //      favouriteImageView.image = UIImage(named: "WhiteHeart")
        }
    }

    func configTableView() {
        applicablePlaceTableView.delegate = self
        applicablePlaceTableView.dataSource = self
        supportTableView.delegate = self
        supportTableView.dataSource = self
        applicablePlaceTableViewHeightConnstrant.constant = applicablePlaceTableView.contentSize.height
        applicablePlaceTableView.register(UINib(nibName: "ApplicablePlaceViewCell", bundle: nil), forCellReuseIdentifier: "ApplicablePlaceViewCell")
        supportTableView.register(UINib(nibName: "SupportCell", bundle: nil), forCellReuseIdentifier: "SupportCell")
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func useVoucherButtonTapped(_ sender: Any) {
        if readyToUse {
            if let voucherId = self.redeemedVoucherId,
               voucherId != "",
               let codeSecret = self.codeSecret {
                self.didUseVoucher(codeSecret)
                //        presenter.useVoucher(with: voucherId)
            } else {
                self.showCustomAlert(withTitle: "alert.no_data".localized,
                                     andContent: "alert.no_data_content".localized)
            }
        } else {
            let userData = Storage.shared.loginData
            let activePoint = Float(userData?.workingSite?.customerBalance?.amountActive ?? "0") ?? 0
            let formatted = Int(activePoint)
            let price = Int(Float(voucherPriceLabel.text ?? "0") ?? 0)
            if formatted >= price {
                let paragraph = NSMutableParagraphStyle()
                paragraph.alignment = .center
                paragraph.lineSpacing = 8.0
                let attribute1 = NSAttributedString(string: "voucher.use_voucher_confirm1".localized,
                                                    attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                                 .foregroundColor: UIColor(hexString: "727C88")!,
                                                                 .paragraphStyle: paragraph])
                let attribute2 = NSAttributedString(string: voucherPriceLabel.text ?? "",
                                                    attributes: [.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                                                 .foregroundColor: UIColor(hexString: "000000")!,
                                                                 .paragraphStyle: paragraph])
                let attribute3 = NSAttributedString(string: "voucher.use_voucher_confirm2".localized,
                                                    attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                                 .foregroundColor: UIColor(hexString: "727C88")!,
                                                                 .paragraphStyle: paragraph])
                let attribute = NSMutableAttributedString()
                attribute.append(attribute1)
                attribute.append(attribute2)
                attribute.append(attribute3)
                self.showTwoButtonsAlert(information: attribute, with: .useVoucherAlert) {
                    [weak self] in
                    var messageContent = ""
                    if(self?.voucherDetail?.itemMode == ItemImportMode.ITEM_IMPORTED_AT_TIME_OF_REDEMPTION.string){
                        messageContent = "voucher.ITEM_IMPORT_MODE".localized
                    }
                    self?.presenter.redeemVoucher(voucherId: self?.voucherId ?? "",
                                                  messageContent: "")
                }
            } else {
                showCustomAlert(withTitle: "alert.not_enough_point_header".localized, andContent: "alert.not_enough_point".localized)
            }
        }
    }
    
    func display(voucherDetail: VoucherDetail) {
        DispatchQueue.main.async {

            self.voucherDetail = voucherDetail
            self.customizeLikeButton(liked: self.liked)
            // Image
            if let imageUrl = voucherDetail.images?.first?.imageURL, let url = URL(string: imageUrl) {
                self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.imageView.image = UIImage(named: "alter")
                //          self.imageContainerView.isHidden = true
            }
            // Name
            if let name = voucherDetail.name, (name != "") {
                self.voucherTitleLabel.text = name
            } else {
                self.titleContainerView.isHidden = true
            }
            // Price
            if let price = voucherDetail.prices?.first?.payPoint {
                let priceValue = Double(price) ?? 0
                if priceValue == 0 {
                    self.voucherPriceLabel.text = "voucher.free".localized
                } else {
                    self.voucherPriceLabel.text = String(format: "personal.point_value".localized,
                                                         priceValue.formattedWithSeparator)
                }
            } else {
                self.priceContainerView.isHidden = true
            }

            if let endTime = voucherDetail.endTime?.toDate() {
                let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
                let currentDate = Date()
                self.expireDateLabel.text = voucherDetail.endTime?.dateToString(fromFormat: "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy")
                if currentDate < endTime {
                    let difference = Calendar.current.dateComponents(components, from: currentDate, to: endTime)
                    //          let difference = self.calculaterRemainingTime(endDate: endTime)
                    if (difference.day ?? 0) < 1 {
                        if difference.hour == 0 {
                            self.remainingTimeView.isHidden = true
                        } else {
                            self.remainingTimeView.backgroundColor = UIColor(hexString: "#F15757")
                            self.remainingLabel.text = "\(difference.hour ?? 0 ) " + "common.hour".localized
                        }
                    } else if difference.day ?? 0 > 3 {
                        self.remainingTimeView.isHidden = true
                    } else {
                        self.remainingTimeView.backgroundColor = UIColor(hexString: "#fcf63d")
                        self.remainingLabel.text = "\(difference.day ?? 0 ) " + "common.day".localized
                    }
                } else {
                    self.expireDateLabel.text = "voucher.expired".localized
                    self.expireDateLabel.textColor = UIColor(hexString: "#FF2828")
                    self.useVoucherContainerView.isHidden = true
                }
            } else {
                self.expireContainerView.isHidden = true
                self.remainingTimeView.isHidden = true
            }

            if voucherDetail.amount == 0 {
                self.remainingTimeView.isHidden = false
                self.remainingTimeView.backgroundColor = UIColor(hexString: "#828282")
                self.remainingLabel.text = "voucher.out_of_stock".localized
                self.remainingLabel.textColor = UIColor(hexString: "#FFFFFF")
            }

            if let brandName = self.voucherBrand?.brandName {
                let supportText = "voucher.detail_support".localized + brandName
                let attribute = self.supportLabel.getAttributeSpacing(inputText: supportText, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: supportText.count)
                attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                          .foregroundColor: UIColor(hexString: "727C88")!],
                                         range: maxRange)
                self.supportLabel.attributedText = attribute
            }

            if let content = voucherDetail.voucherContent?.htmlToString {
                let attribute = self.detailTextView.getAttributeSpacing(inputText: content, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: content.count)
                attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                          .foregroundColor: UIColor(hexString: "727C88")!],
                                         range: maxRange)
                self.detailTextView.attributedText = attribute
            } else {
                self.detailContainerView.isHidden = true
            }

            if let condition = voucherDetail.voucherTermAndCondition?.htmlToString {
                let attributed = self.conditionTextView.getAttributeSpacing(inputText: condition, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: condition.count)
                attributed?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                           .foregroundColor: UIColor(hexString: "727C88")!],
                                          range: maxRange)
                self.conditionTextView.attributedText = attributed
            } else {
                self.conditionContainerView.isHidden = true
            }

            let detailTextViewSize = self.conditionTextView.frame.size
            let maxFloat = CGFloat.greatestFiniteMagnitude
            if let detailHeightContraint = self.detailTextViewHeightConstraint {
                detailHeightContraint.isActive = false
            }
            self.detailTextView.textContainerInset = .zero
            self.detailTextView.textContainer.lineFragmentPadding = 0
            self.detailTextView.dataDetectorTypes = .all
            self.detailHeight = self.detailTextView.sizeThatFits(.init(width: detailTextViewSize.width,
                                                                       height: maxFloat)).height
            self.detailTextView.heightAnchor.constraint(equalToConstant: self.detailHeight).isActive = true
            self.detailTextView.isScrollEnabled = false

            if let conditionHeightContraint = self.conditionTextViewHeightConstraint {
                conditionHeightContraint.isActive = false
            }
            self.conditionTextView.textContainerInset = .zero
            self.conditionTextView.textContainer.lineFragmentPadding = 0
            self.conditionTextView.dataDetectorTypes = .all
            self.conditionHeight = self.conditionTextView.sizeThatFits(.init(width: detailTextViewSize.width,
                                                                             height: maxFloat)).height
            self.conditionTextView.heightAnchor.constraint(equalToConstant: self.conditionHeight).isActive = true
            self.conditionTextView.isScrollEnabled = false
        }
    }
    
    func display(usableVoucherDetail: UsableVoucher) {
        DispatchQueue.main.async {
            // Image
            self.customizeLikeButton(liked: self.liked)
            if let imageUrl = usableVoucherDetail.images?.first?.imageURL, let url = URL(string: imageUrl) {
                self.imageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.imageView.image = UIImage(named: "alter")
            }
            // Name
            if let name = usableVoucherDetail.name, (name != "") {
                self.voucherTitleLabel.text = name
            } else {
                self.titleContainerView.isHidden = true
            }
            // Price
            if let price = usableVoucherDetail.prices?.first?.payPoint {
                if price == "0" {
                    self.voucherPriceLabel.text = "voucher.free".localized
                } else {
                    self.voucherPriceLabel.text = String(format: "personal.point_value".localized, price)
                }
            } else {
                self.priceContainerView.isHidden = true
            }
            // remaining time
            if let endTime = usableVoucherDetail.expiredTime?.toDate() {
                let components: Set<Calendar.Component> = [.second, .minute, .hour, .day, .month, .year]
                let currentDate = Date()
                self.expireDateLabel.text = usableVoucherDetail.expiredTime?.dateToString(fromFormat: "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy")
                if currentDate < endTime {
                    let difference = Calendar.current.dateComponents(components, from: currentDate, to: endTime)
                    //          let difference = self.calculaterRemainingTime(endDate: endTime)
                    if (difference.day ?? 0) < 1 {
                        if difference.hour == 0 {
                            self.remainingTimeView.isHidden = true
                        } else {
                            self.remainingTimeView.backgroundColor = UIColor(hexString: "#F15757")
                            self.remainingLabel.text = "\(difference.hour ?? 0 ) " + "common.hour".localized
                        }
                    } else if difference.day ?? 0 > 3 {
                        self.remainingTimeView.isHidden = true
                    } else {
                        self.remainingTimeView.backgroundColor = UIColor(hexString: "#fcf63d")
                        self.remainingLabel.text = "\(difference.day ?? 0 ) " + "common.day".localized
                    }
                } else {
                    self.expireDateLabel.text = "voucher.expired".localized
                    self.expireDateLabel.textColor = UIColor(hexString: "#FF2828")
                    self.useVoucherContainerView.isHidden = true
                }
            } else {
                self.expireContainerView.isHidden = true
                self.remainingTimeView.isHidden = true
            }
            
            if let brandName = self.voucherBrand?.brandName {
                let supportText = "voucher.detail_support".localized + brandName
                let attribute = self.supportLabel.getAttributeSpacing(inputText: supportText, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: supportText.count)
                attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                          .foregroundColor: UIColor(hexString: "727C88")!],
                                         range: maxRange)
                self.supportLabel.attributedText = attribute
            }

            if let content = usableVoucherDetail.voucherContent?.htmlToString {
                let attribute = self.detailTextView.getAttributeSpacing(inputText: content, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: content.count)
                attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                          .foregroundColor: UIColor(hexString: "727C88")!],
                                         range: maxRange)
                self.detailTextView.attributedText = attribute
            } else {
                self.detailContainerView.isHidden = true
            }
            if let condition = usableVoucherDetail.voucherTermAndCondition?.htmlToString {
                let attribute = self.conditionTextView.getAttributeSpacing(inputText: condition, lineSpacing: 8.0)
                let maxRange = NSRange(location: 0, length: condition.count)
                attribute?.addAttributes([.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                          .foregroundColor: UIColor(hexString: "727C88")!],
                                         range: maxRange)
                self.conditionTextView.attributedText = attribute
            } else {
                self.conditionContainerView.isHidden = true
            }

            let detailTextViewSize = self.conditionTextView.frame.size
            let maxFloat = CGFloat.greatestFiniteMagnitude
            self.detailTextViewHeightConstraint?.isActive = false
            self.detailTextView.textContainerInset = .zero
            self.detailTextView.textContainer.lineFragmentPadding = 0
            self.detailTextView.dataDetectorTypes = .all
            self.detailHeight = self.detailTextView.sizeThatFits(CGSize(width: detailTextViewSize.width,
                                                                        height: maxFloat)).height
            self.detailTextView.heightAnchor.constraint(equalToConstant: self.detailHeight).isActive = true
            self.detailTextView.isScrollEnabled = false

            self.conditionTextViewHeightConstraint?.isActive = false
            self.conditionTextView.textContainerInset = .zero
            self.conditionTextView.textContainer.lineFragmentPadding = 0
            self.conditionTextView.dataDetectorTypes = .all
            self.conditionHeight = self.conditionTextView.sizeThatFits(CGSize(width: detailTextViewSize.width,
                                                                              height: maxFloat)).height
            self.conditionTextView.heightAnchor.constraint(equalToConstant: self.conditionHeight).isActive = true
            self.conditionTextView.isScrollEnabled = false
        }
    }
    
    @IBAction func seeMoreButtonTapped(_ sender: Any) {
        if !isExpanded {
            applicablePlaces = listVoucherPlaces?.count ?? 4
            seeMoreButton.setTitle("voucher.see_less".localized, for: .normal)
        } else {
            applicablePlaces = 4
            seeMoreButton.setTitle("voucher.see_more".localized, for: .normal)
        }
        isExpanded = !isExpanded
        DispatchQueue.main.async {
            self.applicablePlaceTableView.reloadData()
            self.applicablePlaceTableView.layoutIfNeeded()
            self.applicablePlaceTableViewHeightConnstrant.constant = self.applicablePlaceTableView.contentSize.height
            self.applicablePlaceTableView.reloadData()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey: Any]?,
                               context: UnsafeMutableRawPointer?) {
        let placeContentHeight = applicablePlaceTableView.contentSize.height
        print("Place content height:", placeContentHeight)
        if applicablePlaceTableViewHeightConnstrant.constant != placeContentHeight {
            applicablePlaceTableViewHeightConnstrant.constant = placeContentHeight
        }
        let supportContentHeight = supportTableView.contentSize.height
        print("Support content height:", supportContentHeight)
        if supportTableViewHeightConstraint.constant != supportContentHeight {
            supportTableViewHeightConstraint.constant = supportContentHeight
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == applicablePlaceTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ApplicablePlaceViewCell", for: indexPath) as? ApplicablePlaceViewCell
            else {
                fatalError("Empty Cell")
            }
            cell.setData(place: listVoucherPlaces?[indexPath.row] ?? StoreList(), brand: voucherBrand ?? Brand())
            if !locationManager.canGetLocation {
                cell.placeDistanceLabel.text = ""
            }
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SupportCell", for: indexPath) as? SupportCell
            else {
                fatalError("Empty Cell")
            }
            switch indexPath.row {
            case 0:
                cell.supportTextLabel.text = self.brandMobile
                cell.supportImageView.image = UIImage(named: "Call")
            case 1:

                cell.supportTextLabel.text = self.brandEmail
                cell.supportImageView.image = UIImage(named: "Call")
            default:
                if let imageUrl = voucherBrand?.logo, let url = URL(string: imageUrl) {
                    cell.supportImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
                    cell.supportImageView.makeRoundedImage()
                } else {
                    cell.supportImageView.image = UIImage(named: "alter")
                }
                if let name = voucherBrand?.brandName {
                    cell.supportTextLabel.text = name
                } else {
                    cell.supportTextLabel.text = ""
                }

            }
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension VoucherDetailViewController: VoucherDetailProtocols {
    func showError(message: String) {
        self.showCustomAlert(withTitle: "api.error".localized, andContent: message)
    }

    func didUseVoucher(_ code: String) {
        let vc = QRCardViewController()
        vc.setCode(code)
        vc.setVoucher(name: voucherName, image: voucherBrand?.logo ?? "")
        pushFromBottom(vc)
    }

    func display(voucher: VoucherDetail) {
        //      CurrentLocationManager.shared.requestLocation()
        if let likedId = voucher.likeId, likedId != "" {
            self.likeId = likedId
            self.liked = true
        }
        self.display(voucherDetail: voucher)
        self.voucherBrand = voucher.brand
        if let mobile = voucherBrand?.phone, mobile != "" {
            self.brandMobile = mobile
        }
        if let email = voucherBrand?.email, email != "" {
            self.brandEmail = email
        }
        if let name = voucherBrand?.brandName, name != "" {
            self.brandName = name
        }
        DispatchQueue.main.async {
            if let imageUrl = self.voucherBrand?.logo, let url = URL(string: imageUrl) {
                self.logoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.logoImageView.image = UIImage(named: "alter")
            }
        }
        supportTableView.reloadData()
        getListApplicablePlaces(voucherId: self.voucherId)
    }
    
    func display(usableVoucher: UsableVoucher) {
        //        CurrentLocationManager.shared.requestLocation()
        //        startGetMyLocation()
        if let likedId = usableVoucher.likeId, likeId != "" {
            self.likeId = likedId
            self.liked = true
        }
        self.voucherId = usableVoucher.voucherID ?? ""
        self.redeemedVoucherId = usableVoucher.voucherItemID
        self.codeSecret = usableVoucher.codeSecret
        self.voucherName = usableVoucher.name ?? ""
        self.display(usableVoucherDetail: usableVoucher)
        self.voucherBrand = usableVoucher.brand
        if let mobile = voucherBrand?.mobile, mobile != "" {
            self.brandMobile = mobile
        }
        if let email = voucherBrand?.email, email != "" {
            self.brandEmail = email
        }
        if let name = voucherBrand?.brandName, name != "" {
            self.brandName = name
        }
        DispatchQueue.main.async {
            if let imageUrl = self.voucherBrand?.logo, let url = URL(string: imageUrl) {
                self.logoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.logoImageView.image = UIImage(named: "alter")
            }
        }
        supportTableView.reloadData()
        getListApplicablePlaces(voucherId: self.voucherId)
    }

    func showApplicablePlaces(listPlaces: [StoreList]) {
        self.listVoucherPlaces = listPlaces
        if listPlaces.count > applicablePlaces {
            //        DispatchQueue.main.async {
            self.seeMoreButton.isEnabled = true
            self.seeMoreButton.isHidden = false
            //        }
        }
        applicablePlaceTableView.reloadData()
    }

    func showSuccessAlert(redeemedVoucherId: String) {
        self.redeemedVoucherId = redeemedVoucherId
        let text = "voucher.redeem_success".localized + (self.voucherDetail?.endTime?.dateToString(fromFormat: "yyyy-MM-dd HH:mm:ss", "dd-MM-yyyy") ?? "")
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        let attribute1 = NSAttributedString(string: text.localized,
                                            attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                         .foregroundColor: UIColor(hexString: "727C88")!,
                                                         .paragraphStyle: paragraph])
        let attribute = NSMutableAttributedString()
        attribute.append(attribute1)
        self.showTwoButtonsAlertWithImage(information: attribute, with: .useVoucherSuccessAlert,
                                          topButtonCompletion: { [weak self] in
                                            guard let self = self else { return }
                                            self.presenter.getUsableVoucherDetail(voucherId: self.redeemedVoucherId ?? "")
                                            self.useVoucherButton.setTitle("common.use".localized, for: .normal)
                                            self.useVoucherButton.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
                                            self.useVoucherButton.backgroundColor = UIColor(hexString: "#21C777")
                                            self.readyToUse = true
                                          },
                                          bottomButtonCompletion: { [weak self] in
                                            let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
                                            let tabList = CategoryTabViewController()
                                            tabList.title = "voucher.header".localized
                                            tabList.hidesBottomBarWhenPushed = true
                                            let categories = [
                                                CategoryTab(title: "voucher.available".localized,
                                                            viewController: storyboard
                                                                .instantiateViewController(withIdentifier: "MyVouchersViewController") as! MyVouchersViewController),
                                                CategoryTab(title: "voucher.used".localized,
                                                            viewController: storyboard
                                                                .instantiateViewController(withIdentifier: "UsedVoucherViewController") as! UsedVoucherViewController),
                                                CategoryTab(title: "voucher.outdated".localized,
                                                            viewController: storyboard
                                                                .instantiateViewController(withIdentifier: "ExpiredVoucherViewController") as! ExpiredVoucherViewController)
                                            ]
                                            tabList.setTitles(categoryTabs: categories, distribution: .segmented)
                                            self?.navigationController?.pushViewController(tabList, animated: true)
                                          })
    }

    func didLikeVoucher() {
        self.liked = true
        presenter.getVoucherDetail(voucherId: voucherId)
        customizeLikeButton(liked: self.liked)
    }
    
    func didUnlikeVoucher() {
        self.liked = false
        self.likeId = ""
        presenter.getVoucherDetail(voucherId: voucherId)
        customizeLikeButton(liked: self.liked)
    }
}

extension VoucherDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == applicablePlaceTableView {
            if (listVoucherPlaces?.count ?? 0) > applicablePlaces {
                return applicablePlaces
            } else {
                return listVoucherPlaces?.count ?? 0
            }
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == supportTableView {
            switch indexPath.row {
            case 0:
                if self.brandMobile.isEmpty {
                    return 0.0
                } else {
                    return 50.0
                }
            case 1:
                if self.brandEmail.isEmpty {
                    return 0.0
                } else {
                    return 50.0
                }
            default:
                if self.brandName.isEmpty || (self.voucherBrand?.website?.isEmpty ?? "".isEmpty) {
                    return 0.0
                } else {
                    return 50.0
                }
            }
        }
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == supportTableView {
            switch indexPath.row {
            case 0:
                print("tap call")
                let phone = self.brandMobile.trimmed.replacingOccurrences(of: " ", with: "")
                if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            case 1:
                print("tap mail")
                let emailTitle = "support.header".localized
                let toRecipents = [self.brandEmail]
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                guard MFMailComposeViewController.canSendMail() else {
                    showCustomAlert(withTitle: "alert.no_mail".localized,
                                    andContent: "alert.no_mail_app".localized)
                    return
                }
                mc.mailComposeDelegate = self
                mc.setSubject(emailTitle)
                mc.setToRecipients(toRecipents)
                present(mc, animated: true, completion: nil)
            default:
                if let website = voucherBrand?.website, (website.hasPrefix("http://") || website.hasPrefix("https://")) {
                    if let url = URL(string: website) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } else {
                    if let url = URL(string: String(format: "http://%@", voucherBrand?.website ?? "")) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            openGoogleMap(index: indexPath.row)
        }
    }

    func openGoogleMap(index: Int) {
        guard let lat = listVoucherPlaces?[index].latitude, let latDouble =  Double(lat) else { return }
        guard let long = listVoucherPlaces?[index].longitude, let longDouble =  Double(long) else { return }
        showGoogleMap(withLat: latDouble, long: longDouble)
    }
}

extension VoucherDetailViewController: CurrentLocationManagerProtocol {
    func locationDidUpdate(coordinate: CLLocationCoordinate2D) {
        print("updated coordinate: \(coordinate)")
        self.presenter.getVoucherApplicablePlace(voucherId: self.voucherId, lat: "\(coordinate.latitude)", long: "\(coordinate.longitude)")
    }
}

extension VoucherDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        case .sent:
            print("Mail sent")
        case .failed:
            print("Mail sent failure")
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }
}
