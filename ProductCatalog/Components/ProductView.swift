//
//  ProductView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

struct ProductView: View {
    @EnvironmentObject var appManager: ProductViewModel
    @State private var imageProduct: UIImage?
    @State private var isLoading = true
    var product: Product
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.cardApp)
                .frame(height: 120)
                .clipShape(.rect(cornerRadius: 10))
            HStack {
                if isLoading {
                    ProgressView()
                        .frame(width: 64, height: 64)
                        .padding(.leading, 20)
                } else if let image = imageProduct {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .padding(.leading, 20)
                }
                Spacer()
                VStack(alignment: .center) {
                    Text(product.title.uppercased())
                        .font(.headline)
                        .padding(.bottom, 5)
                    HStack{
                        Text("Total: \(product.stock.description)")
                            .padding(.leading, 20)
                            .font(.callout)
                        Spacer()
                        Text("\(product.price.description)$")
                            .padding(.trailing, 20)
                            .font(.largeTitle)
                            .bold()
                    }
                }
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .dynamicTypeSize(.xSmall ... .xLarge)
            }
        }
        .onAppear() {
            loadImage()
        }
    }
    func loadImage() {
        isLoading = true
            appManager.loadImage(url: product.thumbnail) { image in
                self.imageProduct = image
                self.isLoading = false
            }
    }
}

//MARK: - PREVIEW
struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ProductViewModel()
        return ProductView(product: Product(title: "Тестовый продукт", price: 1.99, stock: 5, thumbnail: "https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png"))
            .environmentObject(model)
    }
}
