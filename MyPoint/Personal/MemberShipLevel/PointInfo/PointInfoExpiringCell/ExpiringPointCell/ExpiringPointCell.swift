//
//  ExpiringPointCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

class ExpiringPointCell: UITableViewCell {
  
  @IBOutlet weak var expiringPointLabel: UILabel!
  @IBOutlet weak var expiringDateLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
       // expiringPointLabel.textColor = UIColor(hexString: "#E71D28")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(data: BalanceDetails) {
        let pointNeeded =  Double(data.point ?? "0")
        self.expiringPointLabel.attributedText =
            self.addAttributedTextPointWillExprie(point: pointNeeded!.formattedWithSeparator)
        self.expiringDateLabel.attributedText =
            self.addAttributedTextPointWillExprie(date: data.expiredDate?.dateToString(fromFormat: "yyyy-MM-dd HH:mm:ss", "dd.MM.yyyy") ?? "")
    }
    func addAttributedTextPointWillExprie(point: String) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        
        let attribute1 = NSAttributedString(string: point,
                                            attributes: [.font: UIFont(name: AppFontName.medium, size: 24.0)!,
                                                         .foregroundColor: UIColor(hexString: "E71D28")!,
                                                         .paragraphStyle: paragraph])
       
        let attribute = NSMutableAttributedString()
        attribute.append(attribute1)
        return attribute
    }
    func addAttributedTextPointWillExprie( date: String) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineSpacing = 8.0
        let attribute2 = NSAttributedString(string: String(format: "personal.point_will_exprie2".localized, date),
                                            attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                         .foregroundColor: UIColor(hexString: "727C88")!,
                                                         .paragraphStyle: paragraph])
        
        let attribute = NSMutableAttributedString()
        attribute.append(attribute2)
        return attribute
    }
}
