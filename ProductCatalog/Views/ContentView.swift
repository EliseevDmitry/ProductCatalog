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
        ScrollView(showsIndicators: false){
            LazyVStack {
                ForEach(appManager.products, id: \.id) {item in
                        ProductView(product: item) 
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            appManager.getProducts()
        }
    }
}

//#Preview {
//    ContentView()
//}
