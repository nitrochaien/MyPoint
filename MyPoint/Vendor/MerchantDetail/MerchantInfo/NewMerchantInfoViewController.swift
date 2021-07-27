//
//  NewMerchantInfoViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 3/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation
import UIKit

protocol PageMerchantProperties {
    var contentCaption: String { get set }
    var contentText: String { get set }
    var type: NewMerchantInfoViewController.ContentType { get set }
}

final class NewMerchantInfoViewController: BaseViewController, PagerObserver {
  
    @IBOutlet private weak var tableView: UITableView!
  
    var pageDetail = Page()
  
    var displayItems = [PageMerchantProperties]()
  
    weak var delegate: DidLayoutMerchantInfoProtocol?
  
    enum ContentType: String {
        case text = "text"
        case image = "image"
        case voucher = "voucher"
        case brand = "brand"
        case pageLink = "page_link"
        case header = "header"

        static func getType(from value: String) -> ContentType {
            switch value {
            case ContentType.text.rawValue:
                return .text
            case ContentType.image.rawValue:
                return .image
            case ContentType.voucher.rawValue:
                return .voucher
            case ContentType.brand.rawValue:
                return .brand
            case ContentType.pageLink.rawValue:
                return .pageLink
            default:
                return .header
            }
        }
    }

    struct GeneralPage: PageMerchantProperties {
        var contentCaption: String
        var contentText: String
        var type: ContentType

        let htmlString: NSAttributedString

        init(caption: String, text: String, type: ContentType) {
            contentCaption = caption
            contentText = text
            htmlString = text.htmlToAttributedString ?? NSAttributedString()
            self.type = type
        }
    }

    struct Header: PageMerchantProperties {
        var contentCaption: String
        var contentText: String
        let thumbnail: String
        var type: ContentType

        init(caption: String, text: String, type: ContentType, thumbnail: String) {
            contentCaption = caption
            contentText = text
            self.type = type
            self.thumbnail = thumbnail
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        configTableView()
//        presenter.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if showFirstTime {
//            presenter.requestData()
//        }
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        self.delegate?.updateInfoLayout(height: self.tableView.contentSize.height + 80.0)
    }

    deinit {
//        tableView.removeObserver(self, forKeyPath: "contentSize")
        print("Deinit NewMerchantInfoViewController")
    }

    @IBAction private func onBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

//    func setPageId(_ id: String) {
//        presenter.pageId = id
//    }
  
    func requestData(page: Page) {
      displayItems = [PageMerchantProperties]()
      DispatchQueue.main.async {
        let detail = page

//        let headerItem = Header(caption: detail.title ?? "",
//                                text: detail.publishAtDate ?? "",
//                                                   type: .header,
//                                                   thumbnail: detail.thumbnail ?? "")
//                      self.displayItems.append(headerItem)

        let items = detail.items ?? []
                      for item in items {
                          var newItem: PageMerchantProperties
                          let type = ContentType.getType(from: item.mediaType ?? "")
                          if type == .pageLink {
                              newItem = GeneralPage(caption: item.contentCaption ?? "",
                                                 text: "",
                                                 type: .text)
                              self.displayItems.append(newItem)

                              let pages = item.pages ?? []
                              for page in pages {
                                  let newPage = MerchantInfoModel(with: page)
                                  self.displayItems.append(newPage)
                              }

                          } else {
                              newItem = GeneralPage(caption: item.contentCaption ?? "",
                                                    text: item.contentText ?? "",
                                                    type: type)
                              self.displayItems.append(newItem)
                          }
                      }
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.delegate?.updateInfoLayout(height: self.tableView.contentSize.height + 80.0)
      }
    }
  
      func needsToLoadData(index: Int) {
        requestData(page: pageDetail)
      }
    
      func loadAlways(index: Int) {
        requestData(page: pageDetail)
      }

    private func configTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        tableView.register(UINib(nibName: "PageHeaderTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageHeaderTableViewCell")
        tableView.register(UINib(nibName: "PageTextTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageTextTableViewCell")
        tableView.register(UINib(nibName: "PageImageTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageImageTableViewCell")
        tableView.register(UINib(nibName: "PageVoucherTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "PageVoucherTableViewCell")
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "NewsTableViewCell")
    }
  
}

extension NewMerchantInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = displayItems[indexPath.row]

        switch item.type {
        case .header:
            return headerCell(tableView, indexPath: indexPath)
        case .text:
            return textCell(tableView, indexPath: indexPath)
        case .image:
            return imageCell(tableView, indexPath: indexPath)
        case .voucher:
            return voucherCell(tableView, indexPath: indexPath)
        case .pageLink:
            return newsCell(tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func headerCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageHeaderTableViewCell") as? PageHeaderTableViewCell {
            if let header = displayItems[indexPath.row] as? NewMerchantInfoViewController.Header {
                cell.setData(header)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func textCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageTextTableViewCell") as? PageTextTableViewCell {
            if let page = displayItems[indexPath.row] as? NewMerchantInfoViewController.GeneralPage {
                cell.setData(page)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func imageCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageImageTableViewCell") as? PageImageTableViewCell {
            if let page = displayItems[indexPath.row] as? NewMerchantInfoViewController.GeneralPage {
                cell.setData(page)
                return cell
            }
        }
        return UITableViewCell()
    }

    private func voucherCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "PageVoucherTableViewCell") as? PageVoucherTableViewCell {
            if let page = displayItems[indexPath.row] as? NewMerchantInfoViewController.GeneralPage {
                cell.setData(page)
                cell.openVoucher = { [weak self] in
                    let storyboard = UIStoryboard(name: "VoucherDetail", bundle: nil)
                    let viewController = storyboard
                        .instantiateViewController(withIdentifier: "VoucherDetailViewController") as? VoucherDetailViewController
                    viewController?.voucherId = page.contentText
                    self?.navigationController?.pushViewController(viewController!, animated: true)
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    private func newsCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView
            .dequeueReusableCell(withIdentifier: "NewsTableViewCell") as? NewsTableViewCell {
            if let page = displayItems[indexPath.row] as? NewsModel {
                cell.setData(from: page)
                return cell
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayItems.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if displayItems[indexPath.row].type == .pageLink {
            return 120
        }
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = displayItems[indexPath.row]
        if item.type == .pageLink {
            let vc = NewsDetailViewController()
            let id = (item as? NewsModel)?.id ?? ""
            vc.setPageId(id)
            navigationController?.pushViewController(vc)
        }
    }
}
