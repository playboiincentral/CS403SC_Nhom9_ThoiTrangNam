//
//  ProductListView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 4/21/25.
//

import SwiftUI

enum ProductFilter {
    case type(String)
    case brand(String)
}

struct ProductListView: View {
    @EnvironmentObject private var vm: ViewModel
    @State private var hasLoaded = false  // Đảm bảo fetch chỉ chạy một lần
    @State private var brandName: String = ""

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let filter: ProductFilter
    var body: some View {
        ScrollView {
            if vm.isLoading {
                ProgressView()
                    .padding(.top, 100)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(vm.products) { product in
                        NavigationLink {
                            ProductDetailView(product: product)
                        } label: {
                            ProductCard(product: product)
                        }
                    }
                }
                .onAppear {
                    if !hasLoaded {
                        hasLoaded = true
                        switch filter {
                        case .type(let typeID):
                            vm.fetchProducts(type: typeID)
                        case .brand(let brandID):
                            vm.fetchProducts(brand: brandID)
                        }
                    }
                }
                .padding()
            }
        }
    }
}
