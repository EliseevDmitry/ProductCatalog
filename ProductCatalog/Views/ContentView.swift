//
//  ContentView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var appManager: ProductViewModel
    //debouncer - ограничение по времени запросов при скролинге
    let debouncer = Debouncer(delay: 0.5)
    //MARK: - BODY
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(appManager.products, id: \.uniqID) { item in
                        ProductView(product: item)
                            .onAppear {
                                if item.uniqID == appManager.products.last?.uniqID {
                                    debouncer.debounce {
                                        appManager.getProducts { products in
                                            appManager.products.append(contentsOf: products)
                                        }
                                    }
                                }
                            }
                    }
                }
            }
            .padding(.horizontal, 20)
            .navigationTitle(Constants.firstPageTitle)
            .navigationBarTitleDisplayMode(.large)
            .font(.title)
            .background(Color.bacgroundApp)
            .refreshable {
                appManager.refreshProducts()
                print(Constants.stopLoading)
            }
        }
        .dynamicTypeSize(.xSmall ... .xLarge)
        .onAppear {
            appManager.getProducts { products in
                appManager.products.append(contentsOf: products)
            }
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
