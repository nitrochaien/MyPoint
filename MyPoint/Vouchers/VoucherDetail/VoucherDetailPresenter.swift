//
//  VoucherDetailPresenter.swift
//  MyPoint
//
//  Created by Hieu on 2/3/20.
//  Copyright © 2020 NamDV. All rights reserved.
//

import Foundation

protocol VoucherDetailProtocols: NSObjectProtocol {
    func showError(message: String)

    func display(voucher: VoucherDetail)
    
    func display(usableVoucher: UsableVoucher)

    func showApplicablePlaces(listPlaces: [StoreList])

    func showSuccessAlert(redeemedVoucherId: String)

    func didLikeVoucher()
    
    func didUnlikeVoucher()

    func didUseVoucher(_ code: String)
}

class VoucherDetailPresenter: APIResponseMethods {

    private let service = VoucherServices()
    
    weak var delegate: VoucherDetailProtocols?
    
    func showError(message: String) {
        delegate?.showError(message: message)
    }

    func getVoucherDetail(voucherId: String) {
        print("used: \(voucherId)")
        service.getVoucherDetail(voucherId: voucherId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? VoucherDetailResponse {
                    guard self.noError(from: response) else { return }
                    if let voucher = response.data {
                        //print("voucher: \(voucher)")
                        self.delegate?.display(voucher: voucher)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
    
    func getUsableVoucherDetail(voucherId: String) {
        service.getUsableVoucherDetail(voucherId: voucherId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? UsableVoucherDetailResponse {
                    guard self.noError(from: response) else { return }
                    if let voucher = response.data?.item {
                        self.delegate?.display(usableVoucher: voucher)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func getVoucherApplicablePlace(voucherId: String, lat: String, long: String) {
        service.getVoucherApplicablePlace(voucherId: voucherId, lat: lat, long: long) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? VoucherApplicablePlaceResponse {
                    guard self.noError(from: response) else { return }
                    if let listVoucherPlaces = response.data?.storeList {
                        self.delegate?.showApplicablePlaces(listPlaces: listVoucherPlaces)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }

    func redeemVoucher(voucherId: String, messageContent: String = "") {
        service.redeemVoucher(voucherId: voucherId, messageContent: messageContent) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? RedeemVoucherResponse {
                    guard self.noError(from: response) else { return }
                    if let redeemedVoucherId = response.data?.itemIDS,
                       redeemedVoucherId != "" {
                        print("redeem id: \(redeemedVoucherId)")

                        Storage.shared
                            .loginData?
                            .workingSite?
                            .customerBalance?.setNewAmount(with: response.data?.customerBalance)

                        self.delegate?.showSuccessAlert(redeemedVoucherId: redeemedVoucherId)
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
    
    func useVoucher(voucherId: String) {
        // call api
        //      self.delegate?.showSuccessAlert()
    }

    func likeVoucher(voucherId: String) {
        service.likeBrand(voucherId: voucherId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? LikeBrandResponse {
                    guard self.noError(from: response) else { return }
                    if let likeID = response.data?.likeID, likeID != "" {
                        self.delegate?.didLikeVoucher()
                    } else {
                        self.showError(message: "api.empty".localized)
                    }
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
    }
    
    func unLikeVoucher(likeId: String) {
        service.unLikeBrand(likeId: likeId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? UnLikeBrandResponse {
                    guard self.noError(from: response) else { return }
                    self.delegate?.didUnlikeVoucher()
                } else {
                    self.showError(message: "api.request_fail".localized)
                }
            }
        }
    }

    func useVoucher(with voucherId: String, messageContent: String = "") {
        service.redeemMyVoucher(voucherId: voucherId) { [weak self] (response, success) in
            guard let self = self else { return }
            if success {
                if let response = response as? MyVoucherRedeemResponse {
                    guard self.noError(from: response) else {
                        return
                    }
                    self.delegate?.didUseVoucher(response.data?.voucherCode ?? "")
                }
            } else {
                self.showError(message: "api.request_fail".localized)
            }
        }
    }
}
