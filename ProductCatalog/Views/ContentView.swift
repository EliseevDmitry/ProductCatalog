//
//  ContentView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: ProductModel

    var body: some View {
        List{
            ForEach(appManager.products, id: \.id) {item in
                Text(item.title)
            }
        }
            .onAppear {
                appManager.getProducts()
            }
    }
}

#Preview {
    ContentView()
}
