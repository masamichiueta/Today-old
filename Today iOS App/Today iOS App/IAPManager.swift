//
//  IAPManager.swift
//  Today
//
//  Created by UetaMasamichi on 9/11/16.
//  Copyright © 2016 Masamichi Ueta. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (_ success: Bool, _ products: [SKProduct]?) -> ()
public typealias ProductPaymentHandler = (_ state: SKPaymentTransactionState, _ error: Error?) -> ()

public class IAPManager : NSObject  {
    
    fileprivate let productIdentifiers: Set<ProductIdentifier>
    fileprivate var purchasedProductIdentifiers = Set<ProductIdentifier>()
    fileprivate var productsRequest: SKProductsRequest?
    fileprivate var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
    fileprivate var productPaymentHandler: ProductPaymentHandler?
    
    static let IAPHelperPurchaseNotification = "IAPHelperPurchaseNotification"
    
    public init(productIds: Set<ProductIdentifier>) {
        self.productIdentifiers = productIds
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
}

// MARK: - StoreKit API

extension IAPManager {
    
    public func requestProducts(completionHandler: ProductsRequestCompletionHandler?) {
        
        productsRequest?.cancel()
        productsRequestCompletionHandler = completionHandler
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
        
    }
    
    public func buyProduct(_ product: SKProduct, productPaymentHandler: ProductPaymentHandler?) {
        print("Buying \(product.productIdentifier)...")
        let payment = SKPayment(product: product)
        self.productPaymentHandler = productPaymentHandler
        SKPaymentQueue.default().add(payment)
    }

    public class func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
}


extension IAPManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("load list of products")
        
        let products = response.products
        productsRequestCompletionHandler?(true, products)
        clearRequestAndHandler()
        
        for p in products {
            print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
        }
        
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletionHandler!(false, nil)
        clearRequestAndHandler()
    }
    
    fileprivate func clearRequestAndHandler() {
        productsRequest = nil
        productsRequestCompletionHandler = nil
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                self.productPaymentHandler?(.purchased, nil)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing:
                self.productPaymentHandler?(.purchasing, nil)
                break
            case .failed:
                self.productPaymentHandler?(.failed, transaction.error)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored, .deferred:
                break
            }
        }
    }
}
