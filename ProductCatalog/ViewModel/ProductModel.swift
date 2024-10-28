//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation
import UIKit



final class ProductModel: ObservableObject {
    
    @Published var products: [Product] = []
    //@Published var productImage: UIImage?
    
    private let limit = 20 //есть возможность изменить в дальнейшем размер количества загруженных товаров
    private var cache = NSCache<NSString, UIImage>()
    
    private var skip = Int()
    var netWork = NetworkServise()
    
    func updateSkip(){
        skip += limit
    }
    
    func getProducts(completion: @escaping ([Product]?) -> Void) {
        
        print(networkRequest.getURLString(limit: limit, skip: skip))
        netWork.fetchProducts(urlString: networkRequest.getURLString(limit: limit, skip: skip)) { result in
            switch result {
            case .success(let requestProducts):
               // self.products = requestProducts.products
                //self.skip = requestProducts.skip
                completion(requestProducts.products)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
//    func loadImage(url: String) -> UIImage? {
//        var imageResult: UIImage?
//        if let cachedImage = getImage(forKey: url) {
//            return cachedImage
//        } else {
//            netWork.fetchImage(urlString: url) { result in
//                switch result {
//                case .success(let image):
//                    self.setImage(image, forKey: url)
//                    imageResult = image
//                case .failure(let error):
//                    print(error.localizedDescription)
//                    imageResult = nil
//                }
//            }
//            return imageResult
//        }
//    }
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = getImage(forKey: url) {
            completion(cachedImage)
        } else {
            netWork.fetchImage(urlString: url) { result in
                switch result {
                case .success(let image):
                    self.setImage(image, forKey: url)
                    completion(image)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil)
                }
            }
        }
    }
    
}




