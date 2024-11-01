//
//  CacheService.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 30.10.2024.
//

import UIKit

final class CasheService {
    //сервис кэширования загруженных изображений товаров
    private var cache = NSCache<NSString, UIImage>()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
    
}
