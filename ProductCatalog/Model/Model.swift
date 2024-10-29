//
//  Model.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

//предусмотрены только запросы GET (поэтому подписываем только под протокол Decodable)
//для реализации пагинации запрашиваем общее количество товара - total, количество пропущеных обьеков - skip, количество объхектов, которые мы запрашиваем - limit (по условию задачи 20 товаров/стр.)
struct Products: Decodable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

//в структуре JSON - есть ID (он не уникальный, поэтому пришлось создавать свой uniqID: UUID - для дальнейшего управления данными)
//также ограничем запрос набором свойств у обьекта из задания (product name, image, price, and quantity)
//по условиям задачи требуется после загрузки изменить размер картинки до "64x64 pixels", API позволяет загрузить "миниатюру" картинки из сети, что существенно увеличит скорость загрузки данных (условие 64x64 pixels - будет выполнено)
struct Product: Decodable {
    let title: String
    let price: Float
    let stock: UInt //товарный остаток не может быть меньше 0 поэтому UInt вместо Int
    let thumbnail: String
    let uniqID: UUID
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, stock, thumbnail
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(Float.self, forKey: .price)
        self.stock = try container.decode(UInt.self, forKey: .stock)
        self.thumbnail = try container.decode(String.self, forKey: .thumbnail)
        self.uniqID = UUID()
    }
    
    // Инициализатор для PreviewProvider - ProductView
    init(title: String, price: Float, stock: UInt, thumbnail: String) {
        self.title = title
        self.price = price
        self.stock = stock
        self.thumbnail = thumbnail
        self.uniqID = UUID()
    }
}
