//
//  ProductCard.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 4/9/25.
//

import SwiftUI

struct ProductCard: View {
    var product: Product
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            if let firstImg = product.imgs.first, let url = URL(string: firstImg) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
            }
            Text(product.brandID)
                .fontWeight(.semibold)
            Text(product.name)
                .fontWeight(.light)
            Text("\(product.price, specifier: "%.0f") vnđ")
                .fontWeight(.bold)
        }
        .font(.body)
        .foregroundStyle(.black)
    }
}
