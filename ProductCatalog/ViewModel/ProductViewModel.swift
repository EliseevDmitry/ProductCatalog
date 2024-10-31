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
    private var isLoading = false
    private let limit = 20 //лимит запроса (количество товара)
    private var total = Int()
    private var currentSkip = Int()
    private var skip: Int {
        get{
            if total >= (currentSkip + limit) {
               return currentSkip + limit
            } else if total < (currentSkip + limit) {
                return (self.total - currentSkip) + currentSkip
            }
            return Int()
        }
        set{
            currentSkip = newValue
        }
    }
    
    
    func getProducts(completion: @escaping ([Product]) -> Void) {
        guard !isLoading else { return } // если уже идет загрузка, выходим
                isLoading = true // устанавливаем флаг загрузки
        print(networkRequest.getURLString(limit: limit, skip: self.skip))
        if !products.isEmpty && self.skip == self.total { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.05) {
            self.netWork.fetchProducts(urlString: networkRequest.getURLString(limit: self.limit, skip: self.skip)) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    switch result {
                    case .success(let requestProducts):
                        self.total = requestProducts.total
                        self.skip = requestProducts.skip
                        completion(requestProducts.products)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.getImage(forKey: url) {
            completion(cachedImage)
        } else {
            netWork.fetchImage(urlString: url) { result in
                DispatchQueue.main.async {
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
    
}




