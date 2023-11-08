//
//  ContentView.swift
//  StoreKit2Tutorial
//
//  Created by Thompson Dean on 2023/11/07.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var storeKitManager = StoreKitManager()
    @State var isShowingAlert: Bool = false
    let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(storeKitManager.items, id: \.self) { product in
                            VStack {
                                if storeKitManager.isProductPurchased(product.id) {
                                    NavigationLink {
                                        DetailView(imageString: product.id)
                                    } label: {
                                        Image(product.id)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: geo.size.width / 2 - 20, height: geo.size.width / 2 - 20)
                                            .clipped()
                                            .cornerRadius(8)
                                    }
                                } else {
                                    Image(product.id)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width / 2 - 20, height: geo.size.width / 2 - 20)
                                        .clipped()
                                        .cornerRadius(8)
                                        .onTapGesture {
                                            storeKitManager.selectProductForPurchase(product)
                                            isShowingAlert = true
                                        }
                                }
                                
                                Button {
                                    Task {
                                        await storeKitManager.purchase(product)
                                    }
                                } label: {
                                    Text(storeKitManager.isProductPurchased(product.id) ? "Purchased" : "Buy Now \(product.displayPrice)")
                                        .padding(8)
                                        .frame(width: geo.size.width / 2 - 20)
                                        .foregroundColor(.white)
                                        .background(storeKitManager.isProductPurchased(product.id) ? .green : .blue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(12)
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                            title: Text("Purchase needed"),
                            message: Text("Would you like to buy \(storeKitManager.selectedProductForPurchase?.displayPrice ?? "") to view this picture?"),
                            primaryButton: .default(Text("Buy Now")) {
                                Task {
                                    await storeKitManager.purchaseSelectedProduct()
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
            }
            .navigationTitle("App Div")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
