//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation


final class ProductModel: ObservableObject {
    
    @Published var products: [Product] = []
    
    let limit = 20 //есть возможность изменить в дальнейшем размер количества загруженных товаров
    var skip = Int()
    var netWork = NetworkServise()

    func getProducts() {
        netWork.fetchProducts(urlString: networkRequest.getURLString(limit: limit, skip: skip)) { result in
            switch result {
            case .success(let requestProducts):
                self.products = requestProducts.products
                self.skip = requestProducts.skip
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
    

