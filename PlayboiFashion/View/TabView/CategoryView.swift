//
//  CategoryView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct CategoryView: View {
    let categories = [
        ("tshirt","T-shirt", "category_tshirt"),
        ("jeans","Jeans", "category_jeans"),
        ("jacket","Jacket", "category_jacket"),
        ("shoes","Shoes", "category_shoes"),
        ("watch","Watch", "category_watch"),
        ("wallet","Wallet", "category_wallet"),
        ("sunglasses","Sunglasses", "category_sunglass"),
        ("backpack","Backpack", "category_backpack")
    ]
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(categories, id: \.0) {
                    index in
                    NavigationLink {
                        ProductListView(filter: .type(index.0))
                    } label: {
                        CategoryCard(categoryName: index.1, categoryImg: index.2)
                    } .padding(5)
                }
            } .padding()
        }
    }
}

struct CategoryCard: View {
    let categoryName: String
    let categoryImg: String
    var body: some View {
        HStack {
            Text(categoryName)
            Spacer()
            Image(categoryImg)
                .resizable()
                .scaledToFill()
                .frame(width: 135, height: 135)
            Image(systemName: "chevron.right")
        }   .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.gray.opacity(0.08))
            )
    }
}

#Preview {
    CategoryView()
}
