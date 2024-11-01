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
    private var netWork = NetworkService() //сетевой сервис
    private var cache = CasheService() // сервис кэширования загруженных изображений
    let dispatchGroup = DispatchGroup()
    private var isLoading = false // флаг загрузки
    private let limit = 20 //лимит запроса (количество товара)
    private var total = Int() //обновляем из сети количество возможных зля запроса сущностей Product
    private var currentSkip = Int()
    //вычисляемое свойство skip задание смещения при сетевом запросе, а также контроль за максимальным количеством запрашиваемых элементов из сети (total < (currentSkip + limit))
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
    
    //запрос сущности типа Products
    func getProducts(completion: @escaping ([Product]) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        if !products.isEmpty && self.skip == self.total {
            isLoading = false
            return
        }
        dispatchGroup.enter()
        // Выполняем сетевой запрос в потоке qos: .default
        DispatchQueue.global(qos: .default).async {
            self.netWork.fetch(urlString: NetworkRequest.getURLString(limit: self.limit, skip: self.skip)) { result in
                // Возвращаемся на главный поток для обновления UI
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.dispatchGroup.leave()
                    switch result {
                    case .success(let data):
                        do {
                            //декодирование Data() полученных из сети в сущность типа Products
                            let products = try JSONDecoder().decode(Products.self, from: data)
                            self.total = products.total
                            self.skip = products.skip
                            completion(products.products)
                        } catch {
                            print("Error to decode JSON decode", error.localizedDescription)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //запрос изображений сущностей типа Product
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.getImage(forKey: url) {
            completion(cachedImage)
            return
        }
        dispatchGroup.enter()
        // Выполняем сетевой запрос в потоке qos: .default
        DispatchQueue.global(qos: .default).async {
            self.netWork.fetch(urlString: url) { result in
                // Возвращаемся на главный поток для обновления UI
                DispatchQueue.main.async {
                    self.dispatchGroup.leave()
                    switch result {
                    case .success(let data):
                        //инициализируем UIImage() через Data()
                        if let image = UIImage(data: data) {
                            self.cache.setImage(image, forKey: url)
                            completion(image)
                        } else {
                            //в случае неудачи - возвращаем системную картинку
                            completion(UIImage(systemName: Constants.image))
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
            }
        }
    }
    
    //вункция отмены запроса сущности типа Products при Pull-to-Refresh в ContentView
    func refreshProducts() {
        guard !isLoading else { return }
        isLoading = true
        getProducts { products in
            self.products = products
            self.isLoading = false
        }
    }
}
