//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

fileprivate let appManager = ProductViewModel()

@main
struct ProductCatalogApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appManager)
        }
    }
}
