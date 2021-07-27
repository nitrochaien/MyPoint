//
//  MembershipPrivilegeViewController.swift
//  MyPoint
//
//  Created by Hieu Nguyen on 2/11/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

protocol DidLayoutMembershipPrivilegeProtocol: NSObjectProtocol {
    func updateLayout(size: CGSize)
}

class MembershipPrivilegeViewController: UIViewController, PagerObserver {  

    @IBOutlet weak var privilegeHeaderLabel: UILabel!
    @IBOutlet weak var privilegeContentLabel: UILabel!
    @IBOutlet weak var privilegeDescriptionLabel: UILabel!
    @IBOutlet weak var privilegeConditionLabel: UILabel!

    weak var delegate: DidLayoutMembershipPrivilegeProtocol?

    var index = 0
    
    var listLevel = [Level]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    func needsToLoadData(index: Int) {
        let frameSize = view.frame.size
        privilegeHeaderLabel.text = String(format: "personal.privilege_header".localized, listLevel[index].membershipLevelName ?? "")
        privilegeContentLabel.attributedText =
            listLevel[index].membershipLevelContent?.membershipHTMLString
        privilegeDescriptionLabel.attributedText =
            listLevel[index].membershipLevelTermAndCondition?.membershipHTMLString
        privilegeConditionLabel.attributedText =
            listLevel[index].membershipLevelDescription?.membershipHTMLString

        let headerHeight = privilegeContentLabel
            .text?
            .height(withConstrainedWidth: frameSize.width - 40,
                    font: UIFont(name: AppFontName.medium, size: 16.0)!) ?? 0.0

        let contentHeight = privilegeContentLabel
            .text?
            .height(withConstrainedWidth: frameSize.width - 40,
                    font: UIFont(name: AppFontName.regular, size: 14.0)!) ?? 0.0

        let descriptionHeight = privilegeDescriptionLabel
            .text?
            .height(withConstrainedWidth: frameSize.width - 40,
                    font: UIFont(name: AppFontName.regular, size: 14.0)!) ?? 0.0

        let conditionHeight = privilegeConditionLabel
            .text?
            .height(withConstrainedWidth: frameSize.width - 40,
                    font: UIFont(name: AppFontName.regular, size: 14.0)!) ?? 0.0

        let height = headerHeight + contentHeight + descriptionHeight + conditionHeight + 122
        delegate?.updateLayout(size: CGSize(width: frameSize.width, height: height))
    }
}
