//
//  TwoOptionsButtonWithImage.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/4/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

struct TwoOptionsButtonWithImage {
  let title: String
  let content: NSAttributedString
  let image: UIImage
  let topButtonTitle: String
  let bottomButtonTitle: String
  let type: AlertType
  
  enum AlertType {
      case normal
      case destructive
      case confirm
  }
  
  init(title: String,
       content: NSAttributedString,
       topButtonTitle: String,
       image: UIImage,
       bottomButtonTitle: String,
       type: AlertType) {
      self.title = title
      self.content = content
      self.topButtonTitle = topButtonTitle
      self.bottomButtonTitle = bottomButtonTitle
      self.type = type
      self.image = image
  }
  
  static var useVoucherSuccessAlert: TwoOptionsButtonWithImage {
      let content = "voucher.use_voucher_confirm1".localized + "voucher.use_voucher_confirm2".localized
      let paragraph = NSMutableParagraphStyle()
      paragraph.alignment = .center
      paragraph.lineSpacing = 8.0
      let attribute = NSAttributedString(string: content,
                                         attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                      .foregroundColor: UIColor(hexString: "727C88")!,
                                                      .paragraphStyle: paragraph])
      return TwoOptionsButtonWithImage(title: "Đổi ưu đãi thành công!".localized,
                                   content: attribute,
                                   topButtonTitle: "common.understand".localized,
                                   image: UIImage(named: "img_success")!,
                                   bottomButtonTitle: "voucher.view_my_voucher".localized,
                                   type: .confirm)
  }
}
