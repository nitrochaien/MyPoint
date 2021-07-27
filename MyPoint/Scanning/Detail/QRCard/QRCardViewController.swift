//
//  QRCardViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import Alamofire

final class QRCardViewController: UIViewController {

    @IBOutlet private weak var barCodeView: UIView!
    @IBOutlet private weak var barCodeLabel: UILabel!
    @IBOutlet private weak var barCodeImageView: UIImageView!
    @IBOutlet private weak var qrCodeImageView: UIImageView!

    @IBOutlet private weak var noInternetImageView: UIImageView!

    @IBOutlet private weak var userInfoView: UIView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var pointLabel: UILabel!

    @IBOutlet private weak var productView: UIView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!

    @IBOutlet private weak var voucherCodeView: UIView!
    @IBOutlet private weak var voucherCodeLabel: UILabel!
    @IBOutlet private weak var voucherImageView: UIImageView!

    private let presenter = QRCardPresenter()
    var isShowCancelButton = false

    let reachability = NetworkReachabilityManager()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reachability?.startListening()
        reachability?.listener = { [weak self] status in
            guard let self = self else { return }

            switch status {
            case .notReachable:
                self.enterNoNetworkState()
            case .reachable(.ethernetOrWiFi),
                 .reachable(.wwan):
                self.enterHavingNetworkState()
            default:
                break
            }
        }
    }

    private func enterNoNetworkState() {
        noInternetImageView.isHidden = false
        userInfoView.isHidden = true
        productView.isHidden = true
        barCodeView.isHidden = true
        qrCodeImageView.isHidden = true

        presenter.invalidateTimer()
    }

    private func enterHavingNetworkState() {
        noInternetImageView.isHidden = true
        userInfoView.isHidden = false
        productView.isHidden = false
        barCodeView.isHidden = false
        qrCodeImageView.isHidden = false

        if presenter.cardType == .userInfo {
            presenter.performUpdateCardNumberPeriodically()
            presenter.delegate = self
        } else {
            initUI()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.invalidateTimer()
        reachability?.stopListening()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func initUI() {
        cancelButton.isHidden = !isShowCancelButton

        switch presenter.cardType {
        case .voucher:
            voucherCodeView.isHidden = false
            productView.isHidden = false
            productNameLabel.text = presenter.voucherName
            voucherCodeLabel.text = presenter.code
            voucherImageView.setImage(withURL: presenter.voucherImage)
        case .userInfo:
            voucherCodeView.isHidden = true
            userInfoView.isHidden = false
            barCodeLabel.text = presenter.code

            let data = Storage.shared.loginData
            usernameLabel.text = data?.workerSite?.usernameDisplay
            pointLabel.text = data?.workingSite?.customerBalance?.amountActiveDisplay
        }

        barCodeImageView.image = generateBarcode(from: presenter.code)
        qrCodeImageView.image = generateQRCode(from: presenter.code)
    }

    func setCode(_ code: String) {
        presenter.code = code
    }

    func setVoucher(name: String, image: String) {
        presenter.cardType = .voucher
        presenter.voucherName = name
        presenter.voucherImage = image
        isShowCancelButton = true
    }

    @IBAction private func onDismiss(_ sender: Any) {
        popFromTop()
    }

    private func generateBarcode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setDefaults()
            // Margin
            filter.setValue(7.00, forKey: "inputQuietSpace")
            filter.setValue(data, forKey: "inputMessage")
            // Scaling
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                let context: CIContext = CIContext.init(options: nil)
                let cgImage: CGImage = context.createCGImage(output, from: output.extent)!
                let rawImage: UIImage = UIImage.init(cgImage: cgImage)

                // Refinement code to allow conversion to NSData or share UIImage. Code here:
                //http://stackoverflow.com/questions/2240395/uiimage-created-from-cgimageref-fails-with-uiimagepngrepresentation
                let cgimage: CGImage = (rawImage.cgImage)!
                let cropZone = CGRect(x: 0, y: 0, width: Int(rawImage.size.width), height: Int(rawImage.size.height))
                let cWidth: size_t  = size_t(cropZone.size.width)
                let cHeight: size_t  = size_t(cropZone.size.height)
                let bitsPerComponent: size_t = cgimage.bitsPerComponent
                // THE OPERATIONS ORDER COULD BE FLIPPED, ALTHOUGH, IT DOESN'T AFFECT THE RESULT
                let bytesPerRow = (cgimage.bytesPerRow) / (cgimage.width  * cWidth)

                let context2: CGContext = CGContext(data: nil,
                                                    width: cWidth,
                                                    height: cHeight,
                                                    bitsPerComponent: bitsPerComponent,
                                                    bytesPerRow: bytesPerRow,
                                                    space: CGColorSpaceCreateDeviceRGB(),
                                                    bitmapInfo: cgimage.bitmapInfo.rawValue)!

                context2.draw(cgimage, in: cropZone)

                let result: CGImage  = context2.makeImage()!
                let finalImage = UIImage(cgImage: result)

                return finalImage

            }
        }

        return nil
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 4, y: 4)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}

extension QRCardViewController: BaseProtocols {
    func requestSuccess() {
        initUI()
    }
}
