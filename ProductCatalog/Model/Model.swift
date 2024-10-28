//
//  Model.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

//предусмотрены только запросы GET (поэтому подписываем только под протокол Decodable)
//для реализации пагинации запрашиваем общее количество товара - total, количество пропущеных обьеков - skip, количество объхектов которые мы запрашиваем - limit (по условию задачи 20 товаров/стр.)
struct Products: Decodable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

//в структуре JSON - есть ID (в рамках тестовой задачи - предположим, что он уникальный)
//также ограничем запрос набором свойств у обьекта из задания (product name, image, price, and quantity)
//по условиям задачи требуется после загрузки изменить размер картинки до "64x64 pixels", API позволяет загрузить "миниатюру" картинки из сети, что существенно увеличит скорость загрузки данных (условие 64x64 pixels - будет выполнено)
struct Product: Decodable {
    let id: Int
    let title: String
    let price: Float
    let stock: UInt //товарный остаток не может быть меньше 0 поэтому UInt вместо Int
    let thumbnail: String
}
