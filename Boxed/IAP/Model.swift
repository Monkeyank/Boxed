//
//  Model.swift
//  Boxed
//
//  Created by Ankith on 7/19/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import Foundation
import StoreKit

class Model {
    
    struct IAP: Codable, SettingsManageable {
        var didPay1 = false
    }
    
    var purchaseInfo = IAP()
    
    var products = [SKProduct]()
    
    
    init() {
        _ = purchaseInfo.load()
    }
    
    
    func getProduct(containing keyword: String) -> SKProduct? {
        return products.filter { $0.productIdentifier.contains(keyword) }.first
    }
}
