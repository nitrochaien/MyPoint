//
//  LanguagePresenter.swift
//  MyPoint
//
//  Created by Nam Vu on 2/16/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

class LanguagePresenter {

    class Language: Decodable {
        let name: String
        let icon: String
        let code: String
        var selected: Bool
    }

    weak var delegate: BaseProtocols?

    var languages = [Language]()

    func generateData() {
        languages = load("languages.json")
        delegate?.requestSuccess()
    }
}
