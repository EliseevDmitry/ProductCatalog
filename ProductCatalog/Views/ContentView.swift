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
                ForEach(appManager.products, id: \.uniqID) {item in
                    ProductView(product: item)
                        .onAppear {
                            if item.uniqID == appManager.products.last?.uniqID {
                                appManager.getProducts(completion: { item in
                                    if let products = item {
                                        appManager.products.append(contentsOf: products)
                                        appManager.updateSkip()
                                    }
                               })
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
             appManager.getProducts(completion: { item in
                 if let products = item {
                     appManager.products.append(contentsOf: products)
                     appManager.updateSkip()
                 }
            })
        }
    }
}

//#Preview {
//    ContentView()
//}
