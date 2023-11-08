//
//  StoreKitManager.swift
//  StoreKit2Tutorial
//
//  Created by Thompson Dean on 2023/11/07.
//

import Foundation
import SwiftUI
import StoreKit

enum PaymentState {
    case successful
    case pending
    case failed
    case userCancelled
}

typealias TransactionListener = Task<Void, Error>
typealias PurchaseResult = Product.PurchaseResult

@MainActor
final class StoreKitManager: ObservableObject {
    let storeKitIdentifiers: [String] = ["akaishi_pet", "ando", "asakura", "tomoaki", "uchida", "ultra", "yoshida"]
    @Published private(set) var items: [Product] = []
    @Published private(set) var purchasedProductIDs: Set<String> = []
    @Published var selectedProductForPurchase: Product?
    @Published private(set) var paymentState: PaymentState? {
        didSet {
            switch paymentState {
            case .failed:
                hasError = true
            default:
                hasError = false
            }
        }
    }
    
    @Published var hasError: Bool = false
    
    private var transactionListener: TransactionListener?
       
       init() {
           transactionListener = configureTransactionListener()
        Task { [weak self] in
            await self?.retrieveProducts()
            await self?.refreshPurchasedProducts()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    func purchase(_ item: Product) async {
        do {
            let result = try await item.purchase()
            
            try await handlePurchase(from: result)
        } catch {
            paymentState = .failed
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func reset() {
        paymentState = nil
    }
    
    func isProductPurchased(_ productID: String) -> Bool {
        return purchasedProductIDs.contains(productID)
    }
    
    func selectProductForPurchase(_ product: Product) {
        selectedProductForPurchase = product
    }
    
    func purchaseSelectedProduct() async {
        if let product = selectedProductForPurchase {
            await purchase(product)
            selectedProductForPurchase = nil
        }
    }
}

extension StoreKitManager {
    func configureTransactionListener() -> TransactionListener {
            Task.detached(priority: .background) { @MainActor [weak self] in
                do {
                    for await result in Transaction.updates {
                        let transaction = try self?.checkVerified(result)
                        self?.paymentState = .successful
                        await transaction?.finish()
                    }
                } catch {
                    self?.paymentState = .failed
                    print(error)
                }
            }
        }
    
    func refreshPurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            switch result {
            case .verified(let transaction):
                if transaction.revocationDate == nil {
                    purchasedProductIDs.insert(transaction.productID)
                }
                await transaction.finish()
            case .unverified(_, _):
                break
            }
        }
    }
    
    func retrieveProducts() async {
        do {
            let products = try await Product.products(for: storeKitIdentifiers).sorted(by: { $0.price < $1.price})
            items = products
            for item in items {
                print(item.displayName)
            }
        } catch {
            paymentState = .failed
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func handlePurchase(from result: PurchaseResult) async throws {
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            paymentState = .successful
            purchasedProductIDs.insert(transaction.productID)
            await transaction.finish()
        case .pending:
            paymentState = .pending
        case .userCancelled:
            paymentState = .userCancelled
        @unknown default:
            break
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, _):
            print("The verfication of the user failed.")
            throw URLError(.cancelled)
        case .verified(let safe):
            return safe
        }
    }
}

