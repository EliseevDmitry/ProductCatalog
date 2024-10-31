//
//  NetworkServise.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation
import UIKit

class Debouncer {
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    private let delay: TimeInterval
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping () -> Void) {
        workItem?.cancel() // Отменяем предыдущий workItem
        workItem = DispatchWorkItem { [weak self] in
            action()
            self?.workItem = nil // Сбрасываем workItem после выполнения
        }
        queue.asyncAfter(deadline: .now() + delay, execute: workItem!)
    }
}

final class NetworkService {
    let debouncer = Debouncer(delay: 0.05)
    
    
    
    func fetchProducts(urlString: String, completion: @escaping (Result<Products, Error>) -> Void) {
        debouncer.debounce {
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                let fetchQueue = DispatchQueue(label: "jsonData", qos: .default, attributes: .concurrent)
                // DispatchQueue.main.async {
                fetchQueue.async {
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
                }
            }.resume()
        }
    }
    
    
    //реализация запроса изображения
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return}
            
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                // DispatchQueue.main.async {
                let fetchQueue = DispatchQueue(label: "jsonData", qos: .userInteractive, attributes: .concurrent)
                // DispatchQueue.main.async {
                fetchQueue.async {
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
                }
            }.resume()
        }
    }



