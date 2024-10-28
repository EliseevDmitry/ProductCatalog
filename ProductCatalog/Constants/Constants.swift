//
//  Constants.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import Foundation

struct networkRequest {
   //формируем запрос JSON - только по интересующим нас позициям - (product name, image, price, and quantity)
   static func getURLString(limit: Int, skip: Int) -> String {
        return "https://dummyjson.com/products?limit=\(limit)&skip=\(skip)&select=title,price,stock,thumbnail"
    }
}
