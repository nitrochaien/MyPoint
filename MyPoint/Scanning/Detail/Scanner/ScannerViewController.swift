//
//  ScannerViewController.swift
//  MyPoint
//
//  Created by Nam Vu on 1/28/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import UIKit
import AVFoundation

final class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    fileprivate var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!

    @IBOutlet private weak var scanAreaView: UIView!
    @IBOutlet private weak var flashButton: UIButton!
    @IBOutlet private weak var cameraView: UIView!
    @IBOutlet private weak var closeButton: UIButton!

    /// If true, this screen is for redeeming voucher.
    /// If false, this screen is for saving point
    var showCancelButton = false

    private let presenter = ScannerPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = cameraView.layer.frame
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)

        captureSession.startRunning()

        presenter.delegate = self

        closeButton.isHidden = !showCancelButton
    }

    func setVoucher(id: String, name: String) {
        presenter.voucherId = id
        presenter.voucherName = name
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction private func onDismiss(_ sender: Any) {
        popFromTop()
    }
    
    @IBAction private func onTapFlashButton(_ sender: Any) {
        toggleFlash()
    }

    private func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        guard device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if device.torchMode == .on {
                device.torchMode = .off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }

    private func failed() {
        let ac = UIAlertController(title: "alert.scanning_not_supported".localized,
                                   message: "alert.scanning_not_supported_content".localized,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "alert.confirm".localized, style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    private func found(code: String) {
        if showCancelButton {
            let categories = code.split(separator: ";")
            let storeId = categories[safe: 1]?.split(separator: "=")[safe: 1] ?? ""
            presenter.redeemVoucher(with: String(storeId))
        } else {
            showRatingScreen()
        }
    }

    private func showRatingScreen() {
        let storyboard = UIStoryboard(name: "Vouchers", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
        vc.setId(presenter.voucherId)
        pushFromBottom(vc)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScannerViewController: ScannerPresenterDelegate {
    func requestSuccess() {
        if showCancelButton {
            let vc = QRCardViewController()
            vc.setCode(presenter.generatedCode)
//            vc.setVoucherName(presenter.voucherName)
            pushFromBottom(vc)
        }
    }

    func didScanFailed() {
        captureSession.startRunning()
    }
}
