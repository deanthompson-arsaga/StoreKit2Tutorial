//
//  ContentView.swift
//  StoreKit2Tutorial
//
//  Created by Thompson Dean on 2023/11/07.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var storeKitManager = StoreKitManager()
    
    let imageNameArray: [String] = ["akaishi_pet", "ando", "asakura", "tomoaki", "uchida", "ultra", "yoshida", "dean"]
    
    let columns: [GridItem] = [.init(.flexible()), .init(.flexible())]
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(imageNameArray, id: \.self) { imageString in
                            VStack {
                                NavigationLink {
                                    DetailView(imageString: imageString)
                                } label: {
                                    Image(imageString)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geo.size.width / 2 - 20, height: geo.size.width / 2 - 20)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                                Button {
                                    print(imageString)
                                } label: {
                                    Text("Buy Now")
                                        .padding(8)
                                        .frame(width: geo.size.width / 2 - 20)
                                        .foregroundColor(.white)
                                        .background(.blue)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(12)
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
