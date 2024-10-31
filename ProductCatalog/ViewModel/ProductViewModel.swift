//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation
import UIKit

final class ProductViewModel: ObservableObject {
    
    @Published var products: [Product] = []
    
    private var netWork = NetworkService()
    private var cache = CasheService()
    private let limit = 20 //лимит запроса (количество товара)
    private var skip = Int() //сдвиг при запросе

    func getProducts(completion: @escaping ([Product]) -> Void) {
        print(networkRequest.getURLString(limit: limit, skip: self.skip))
        netWork.fetchProducts(urlString: networkRequest.getURLString(limit: limit, skip: self.skip)) { result in
            switch result {
            case .success(let requestProducts):
                // self.products = requestProducts.products
                self.skip += self.limit
                completion(requestProducts.products)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.getImage(forKey: url) {
            completion(cachedImage)
        } else {
            netWork.fetchImage(urlString: url) { result in
                switch result {
                case .success(let image):
                    self.cache.setImage(image, forKey: url)
                    completion(image)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
  
}




