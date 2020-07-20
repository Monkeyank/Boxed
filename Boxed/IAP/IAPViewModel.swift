//
//  IAPViewModel.swift
//  Boxed
//
//  Created by Ankith on 7/19/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation
import StoreKit

protocol ViewModelDelegate {
    func toggleOverlay(shouldShow: Bool)
    func willStartLongProcess()
    func didFinishLongProcess()
    func showIAPRelatedError(_ error: Error)
    func shouldUpdateUI()
    func didFinishRestoringPurchasesWithZeroProducts()
    func didFinishRestoringPurchasedProducts()
}


class ViewModel {
    
    // MARK: - Properties
    
    var delegate: ViewModelDelegate?
    
    private let model = Model()
    
    var didPay1: Bool {
        return model.purchaseInfo.didPay1
    }
    
    
    // MARK: - Init
        
    init() {

    }
    
    
    // MARK: - Fileprivate Methods
    
    fileprivate func updateIAPWithPurchasedProduct(_ product: SKProduct) {
        // Update the proper game data depending on the keyword the
        // product identifier of the give product contains.
        if product.productIdentifier.contains("1") {{
            model.purchaseInfo.didPay1= true
        }
        
        // Store changes.
        _ = model.purchaseInfo.update()
        
        // Ask UI to be updated and reload the table view.
        delegate?.shouldUpdateUI()
    }
    
    
    fileprivate func restoreUnlockedMaps() {
        // Mark all maps as unlocked.
        model.purchaseInfo.didPay1 = true
        
        // Save changes and update the UI.
        _ = model.purchaseInfo.update()
        delegate?.shouldUpdateUI()
    }
    
    
    
    // MARK: - Internal Methods
    
    func getProductForItem(at index: Int) -> SKProduct? {
        // Search for a specific keyword depending on the index value.
        let keyword: String
        
        switch index {
        case 0: keyword = "1"
        default: keyword = ""
        }
        
        // Check if there is a product fetched from App Store containing
        // the keyword matching to the selected item's index.
        guard let product = model.getProduct(containing: keyword) else { return nil }
        return product
    }
    
    
    
    // MARK: - Methods To Implement
    
    func viewDidSetup() {
        delegate?.willStartLongProcess()
        
        IAPManager.shared.getProducts { (result) in
            DispatchQueue.main.async {
                self.delegate?.didFinishLongProcess()
                
                switch result {
                    case .success(let products): self.model.products = products
                    case .failure(let error): self.delegate?.showIAPRelatedError(error)
                }
            }
        }
    }
    
    
    func purchase(product: SKProduct) -> Bool {
        if !IAPManager.shared.canMakePayments() {
            return false
        } else {
            delegate?.willStartLongProcess()
            
            IAPManager.shared.buy(product: product) { (result) in
                DispatchQueue.main.async {
                    self.delegate?.didFinishLongProcess()

                    switch result {
                    case .success(_): self.updateIAPWithPurchasedProduct(product)
                    case .failure(let error): self.delegate?.showIAPRelatedError(error)
                    }
                }
            }
        }

        return true
    }
    
    
    func restorePurchases() {
        delegate?.willStartLongProcess()
        IAPManager.shared.restorePurchases { (result) in
            DispatchQueue.main.async {
                self.delegate?.didFinishLongProcess()

                switch result {
                case .success(let success):
                    if success {
                        self.restoreUnlockedMaps()
                        self.delegate?.didFinishRestoringPurchasedProducts()
                    } else {
                        self.delegate?.didFinishRestoringPurchasesWithZeroProducts()
                    }

                case .failure(let error): self.delegate?.showIAPRelatedError(error)
                }
            }
        }
    }
}
