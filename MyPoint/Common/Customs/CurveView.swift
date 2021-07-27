//
//  File.swift
//  MyPoint
//
//  Created by Nam Vu on 2/27/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit

final class CurveView: UIView {

    private var path: UIBezierPath!

    func drawShape() {
        path = UIBezierPath()
        let size = frame.size

        path.move(to: .init(x: 0, y: 0))
        path.addQuadCurve(to: .init(x: 16, y: 8),
                          controlPoint: .init(x: 2, y: 4))
        path.addLine(to: .init(x: size.width - 16, y: 8))
        path.addQuadCurve(to: .init(x: size.width, y: 0),
                          controlPoint: .init(x: size.width - 2, y: 4))
        path.addLine(to: CGPoint(x: size.width, y: size.height))
        path.addLine(to: CGPoint(x: 0, y: size.height))

        path.close()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath

        self.backgroundColor = UIColor.white
        self.layer.mask = shapeLayer
    }
}

private extension CGFloat {
    func toRadians() -> CGFloat {
        return CGFloat(self * .pi / 180)
    }
}
