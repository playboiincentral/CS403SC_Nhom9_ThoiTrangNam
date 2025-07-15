//
//  Banner.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct Banner: View {
    let brands = [
        ("converse", "converseshop"),
        ("urban_revivo", "urbanrevivoshop")
    ]
    var body: some View {
        TabView {
            ForEach(brands, id: \.0) { index in
                NavigationLink {
                    ProductListView(filter: .brand(index.0))
                } label: {
                    Image(index.1)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .clipped()
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 190)
    }
}
