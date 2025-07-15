//
//  ProductSearchCard.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/20/25.
//

import SwiftUI

struct ProductSearchCard: View {
    let product: Product

    var body: some View {
        HStack {
            if let firstImage = product.imgs.first, let url = URL(string: firstImage) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            } else {
                Color.gray
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                    .foregroundStyle(.black)
                Text("\(product.price, specifier: "%.0f") đ")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Image(systemName: "control")
                .font(.title2)
                .foregroundStyle(.black)
                .fontWeight(.semibold)
                .rotationEffect(Angle(degrees: 90))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}



//#Preview {
//    ProductSearchCard()
//}
