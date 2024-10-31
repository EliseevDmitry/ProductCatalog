//
//  ContentView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appManager: ProductViewModel
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVStack {
                ForEach(appManager.products, id: \.uniqID) {item in
                    ProductView(product: item)
                        .onAppear {
                            if item.uniqID == appManager.products.last?.uniqID {
                                appManager.getProducts(completion: { products in
                                    appManager.products.append(contentsOf: products)
                                })
                            }
                        }
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            appManager.getProducts(completion: { products in
                appManager.products.append(contentsOf: products)
            })
        }
    }
}

//MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ProductViewModel()
        return ContentView()
            .environmentObject(model)
    }
}
