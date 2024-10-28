//
//  ContentView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ProductModel()
    var body: some View {
        Text("Тестируем запрос")
            .onAppear {
                viewModel.fetchProducts()
            }
    }
}

#Preview {
    ContentView()
}
