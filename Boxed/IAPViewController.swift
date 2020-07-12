//
//  IAPController.swift
//  Boxed
//
//  Created by Ankith on 7/11/20.
//  Copyright © 2020 Ankith. All rights reserved.
//

import StoreKit

class IAPViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var starterButton: UIButton!
    @IBOutlet weak var restorePurchaseButton: UIButton!
    
    
    var productsRequest = SKProductsRequest()
    var validProducts = [SKProduct]()
    var productIndex = 0
    
    
    // viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        unlockStarterButton.isHidden = true
        
        fetchAvailableProducts()
    }
    
    
    
    func fetchAvailableProducts()  {
        let productIdentifiers = NSSet(objects:
            "com.monkeyank.Boxed.1"  // 0
        )
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            validProducts = response.products
            
            // 1st IAP Product
            let prodUnlockStarter = response.products[1] as SKProduct
            print("1st product: " + prodUnlockStarter.localizedDescription)
            unlockStarterButton.isHidden = false
        }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    
    func purchaseMyProduct(_ product: SKProduct) {
        if self.canMakePurchases() {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else { print("Purchases are disabled in your device!") }
    }
    
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                    
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if productIndex == 0 {
                        print("Thanks for becoming a Donor!")
                        unlockStarterButton.isEnabled = false
                        unlockStarterButton.setTitle("Starter Donation Received", for: .normal)
                    }
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Payment has failed.")
                    break
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    print("Donation has been successfully restored!")
                    break
                    
                default: break
        }}}
    }
    
    
    
    func restorePurchase() {
        SKPaymentQueue.default().add(self as SKPaymentTransactionObserver)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("The Payment was successfull!")
    }
    
    
    
    // Buttons -------------------------------------
    
    @IBAction func unlockStarterButt(_ sender: UIButton) {
        productIndex = 1
        purchaseMyProduct(validProducts[productIndex])
    }
    
    @IBAction func restorePurchaseButt(_ sender: UIButton) {
        restorePurchase()
    }
    
    
}
