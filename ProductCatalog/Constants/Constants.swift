//
//  Constants.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

struct NetworkRequest {
    //формируем запрос JSON - только по интересующим нас позициям - (product name, image, price, and quantity)
    static func getURLString(limit: Int, skip: Int) -> String {
        return "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)&select=title,price,stock,thumbnail"
    }
}

struct Constants {
    static let firstPageTitle = "Products:"
    static let stopLoading = "Остановка загрузки."
    static let total = "Total:"
    //в API отсутствует указание в какой валюте приходят данные, объявлена статическая константа "$", можно было бы реализовать через "Locale.current.currency?.identifier"
    static let currency = "$"
}

struct Preview {
    static let product = Product(title: "Тестовый продукт", price: 1.99, stock: 5, thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png")
}
