//
//  ProductView.swift
//  ProductCatalog
//
//  Created by Dmitriy Eliseev on 28.10.2024.
//

import SwiftUI

struct ProductView: View {
    //MARK: - PROPERTIES
    @EnvironmentObject var appManager: ProductViewModel
    @State private var imageProduct: UIImage?
    @State private var isLoading = true
    var product: Product
    //MARK: - BODY
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
                        .multilineTextAlignment(.center)
                        .font(.headline)
                        .padding(.bottom, 5)
                        .foregroundStyle(.textApp)
                    HStack {
                        Text("\(Constants.total) \(product.stock.description)")
                            .padding(.leading, 20)
                            .font(.callout)
                            .foregroundStyle(.textApp)
                        Spacer()
                        Text("\(product.price.description)\(Constants.currency)")
                            .padding(.trailing, 20)
                            .font(.largeTitle)
                            .foregroundStyle(.textApp)
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
    //MARK: - FUNCTIONS
    private func loadImage() {
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
        return ProductView(product: Preview.product)
            .environmentObject(model)
    }
}
