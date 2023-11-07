//
//  Detailview.swift
//  StoreKit2Tutorial
//
//  Created by Thompson Dean on 2023/11/07.
//

import SwiftUI
import UIKit

struct DetailView: View {
    let imageString: String
    
    var body: some View {
        if let image = UIImage(named: imageString) {
            ImageViewerRepresentable(image: image)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(imageString)
                .navigationBarTitleDisplayMode(.inline)
        } else {
            Text("ERROR")
        }
    }
}
