//
//  NetworkServise.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

final class NetworkServise {

    //сетевой запрос используя тип возвращаемого значения Result
    func fetchProducts(urlString: String, complition: @escaping (Result<Products, Error>)->Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
//            let queue = DispatchQueue(label: "NetworkRequest", attributes: .concurrent)
//            queue.async {
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error", error.localizedDescription)
                    complition (.failure(error))
                }
                guard let data = data else { return }
                do {
                    let products = try JSONDecoder().decode(Products.self, from: data)
                    complition(.success(products))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError.localizedDescription)
                    complition(.failure(jsonError))
                }
            }
        }.resume()
    }
    
}
