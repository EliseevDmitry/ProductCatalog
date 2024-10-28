//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation


class ProductModel: ObservableObject {

    @Published var products: [Product] = []

    
    
//    func fetchProducts() {
//        guard let url = URL(string: networkRequest.url) else { return }
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    print(error.localizedDescription)
//                }
//                guard let data = data else { return }
//                do {
//                    let products = try JSONDecoder().decode(Products.self, from: data)
//                    print(products)
//                } catch let jsonError {
//                     print("Failed to decode JSON", jsonError )
//                }
//                
////                let someString = String(data: data, encoding: .utf8)
////                print(someString ?? "no data")
//            }
//        }.resume()
//    }
    
    func fetchProducts() {
        guard let url = URL(string: networkRequest.url) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                }
                guard let data = data else { return }
                do {
                    let total = try JSONDecoder().decode(TotalProduct.self, from: data)
                    print(total)
                } catch let jsonError {
                     print("Failed to decode JSON", jsonError )
                }
                
//                let someString = String(data: data, encoding: .utf8)
//                print(someString ?? "no data")
            }
        }.resume()
    }
}
    

