//
//  ProductCatalogApp.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

@main
struct ProductCatalogApp: App {
    @StateObject var appManager = ProductModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appManager)
        }
    }
}
