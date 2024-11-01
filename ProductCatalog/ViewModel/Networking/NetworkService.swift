//
//  NetworkServise.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation
import UIKit


final class NetworkService {
    
   
    let dispatchGroupProducts = DispatchGroup()
    let dispatchGroupImages = DispatchGroup()
    private let session: URLSession

        init() {
            let config = URLSessionConfiguration.default
            config.timeoutIntervalForRequest = 30 // 30 секунд
            config.timeoutIntervalForResource = 60 // 60 секунд
            session = URLSession(configuration: config)
        }
    
    
    func fetchProducts(urlString: String, completion: @escaping (Result<Products, Error>) -> Void) {
        dispatchGroupProducts.enter()
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                self.dispatchGroupProducts.leave()
                return
            }
            let queueProducts = DispatchQueue(label: "products", qos: .default, attributes: .concurrent)
            queueProducts.async {
                self.session.dataTask(with: url) { data, response, error in
                    defer { self.dispatchGroupProducts.leave() }
                    if let error = error {
                        print("Error fetching products: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                        let statusCodeError = NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
                        completion(.failure(statusCodeError))
                        return
                    }
                    guard let data = data else {
                        let dataError = NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                        completion(.failure(dataError))
                        return
                    }
                    do {
                        let products = try JSONDecoder().decode(Products.self, from: data)
                        completion(.success(products))
                    } catch let jsonError {
                        print("Failed to decode JSON", jsonError.localizedDescription)
                        completion(.failure(jsonError))
                    }
                }.resume()
            }
        }

    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        dispatchGroupImages.enter()
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            dispatchGroupImages.leave()
            return
        }
        let queueProducts = DispatchQueue(label: "images", qos: .default, attributes: .concurrent)
        queueProducts.async {
            self.session.dataTask(with: url) { data, response, error in
                defer { self.dispatchGroupImages.leave() }
                if let error = error {
                    print("Error fetching image: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response from server"])
                    completion(.failure(statusCodeError))
                    return
                }
                guard let data = data else {
                    let dataError = NSError(domain: "DataError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"])
                    completion(.failure(dataError))
                    return
                }
                guard let image = UIImage(data: data) else {
                    let imageError = NSError(domain: "ImageError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Data is not a valid image"])
                    completion(.failure(imageError))
                    return
                }
                completion(.success(image))
            }.resume()
        }
    }
}
