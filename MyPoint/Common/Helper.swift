//
//  Helper.swift
//  MyPoint
//
//  Created by Nam Vu on 12/29/19.
//  Copyright © 2019 NamDV. All rights reserved.
//

import UIKit

func load<T: Decodable>(_ filename: String,
                        as type: T.Type = T.self) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

struct Helper {
    static func widthForLabel(text: String, height: CGFloat) -> CGFloat {
        let label: UILabel = UILabel(frame: .init(x: 0,
                                                   y: 0,
                                                   width: CGFloat.greatestFiniteMagnitude,
                                                   height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.text = text
        label.sizeToFit()

        return label.frame.width + 20
    }
}
