//
//  PointInfoCell.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 4/13/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol PointInfoProtocols: NSObjectProtocol {
  func showPolicy()
}
class PointInfoCell: UITableViewCell {
  
  @IBOutlet weak var currentPointHeaderLabel: UILabel!
  @IBOutlet weak var currentPointLabel: UILabel!
  @IBOutlet weak var usableLabel: UILabel!
  @IBOutlet weak var accumulatedPointHeaderLabel: UILabel!
  @IBOutlet weak var accumulatedPointLabel: UILabel!
  @IBOutlet weak var accumulatedLabel: UILabel!
  @IBOutlet weak var currentRankHeaderLabel: UILabel!
  @IBOutlet weak var policyLabel: UILabel!
  @IBOutlet weak var currentTrackingPoint: UILabel!
  @IBOutlet weak var currentRankLabel: UILabel!
  @IBOutlet weak var totalTrackingPoint: UILabel!
  @IBOutlet weak var progressBar: UIProgressView!
  @IBOutlet weak var nextRankLabel: UILabel!
  @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var levelLogoImageView: UIImageView!
    weak var delegate: PointInfoProtocols?
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.borderWidth = 0
        containerView.addShadow(ofColor: .lightGray,
                                radius: 8,
                                offset: .zero,
                                opacity: 0.5)
        progressBar.progressTintColor = UIColor(hexString: "#F15757")
        progressBar.trackTintColor = UIColor(hexString: "#FFBCC0")
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPolicy))
        policyLabel.addGestureRecognizer(tap)
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "personal.policy".localized, attributes: underlineAttribute)
        policyLabel.attributedText = underlineAttributedString
        // Initialization code
    }

    @objc private func showPolicy() {
        self.delegate?.showPolicy()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showData(data: CustomerBalanceDetail, listLevels: [Level]) {
        currentPointLabel.text = Double(data.amountTotal ?? "0")?.formattedWithSeparator
        accumulatedPointLabel.text = Double(data.amountTotalOfYear ?? "0")?.formattedWithSeparator
        for (index, currentLevel) in listLevels.enumerated() where currentLevel.levelStartAtDate != nil {
            currentTrackingPoint.text = (currentLevel.accumulatedCounter?.counterValueDisplay ?? "") + "/"
            totalTrackingPoint.text = currentLevel.upgradeWhenCounterIsGreaterOrEqualDisplay
            let nextPoint = Int(Float(currentLevel.upgradeWhenCounterIsGreaterOrEqual ?? "0.0") ?? 0.0)
            let currentPoint = Int(Float(currentLevel.accumulatedCounter?.counterValue ?? "0") ?? 0)
            let pointNeeded =  Double(nextPoint - currentPoint)
            if pointNeeded > 0 {
                self.nextRankLabel.attributedText = self
                    .addAttributedText(text: pointNeeded.formattedWithSeparator,
                                       text2: listLevels[safe: index + 1]?.membershipLevelName ?? "")
            } else {
                self.nextRankLabel.text = "personal.max_rank".localized
            }
            if nextPoint != 0 {
                self.progressBar.progress = Float(currentPoint)/Float(nextPoint)
            } else {
                self.progressBar.progress = 0
            }
            if let url = URL(string: currentLevel.logo ?? "") {
                self.levelLogoImageView.kf.setImage(with: url, placeholder: UIImage(named: "alter"))
            } else {
                self.levelLogoImageView.image = UIImage(named: "alter")
            }
            self.currentRankLabel.text = currentLevel.membershipLevelName
        }
    }
    func addAttributedText(text: String, text2: String) -> NSMutableAttributedString {
      let paragraph = NSMutableParagraphStyle()
      paragraph.alignment = .center
      paragraph.lineSpacing = 8.0
      let attribute1 = NSAttributedString(string: "personal.you_need1".localized,
                                         attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                      .foregroundColor: UIColor(hexString: "727C88")!,
                                                      .paragraphStyle: paragraph])
      let attribute2 = NSAttributedString(string: text,
                                         attributes: [.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                                      .foregroundColor: UIColor(hexString: "000000")!,
                                                      .paragraphStyle: paragraph])
      let attribute3 = NSAttributedString(string: "personal.you_need2".localized,
                                         attributes: [.font: UIFont(name: AppFontName.regular, size: 14.0)!,
                                                      .foregroundColor: UIColor(hexString: "727C88")!,
                                                      .paragraphStyle: paragraph])
      let attribute4 = NSAttributedString(string: text2,
                                          attributes: [.font: UIFont(name: AppFontName.medium, size: 16.0)!,
                                                       .foregroundColor: UIColor(hexString: "000000")!,
                                                       .paragraphStyle: paragraph])
      let attribute = NSMutableAttributedString()
      attribute.append(attribute1)
      attribute.append(attribute2)
      attribute.append(attribute3)
      attribute.append(attribute4)
      return attribute
    }
    
}
