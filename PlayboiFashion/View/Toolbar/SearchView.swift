//
//  SearchView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject private var vm: ViewModel
    @State var txtSearch: String = ""
    var filteredProducts: [Product] {
        let uniqueProducts = Set(vm.products)
        return uniqueProducts.filter { $0.name.localizedCaseInsensitiveContains(txtSearch) }
    }
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Type something...", text: $txtSearch)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25.0)
                            .fill(.gray.opacity(0.35))
                    )
                    .overlay(alignment: .trailing) {
                        ZStack {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.red)
                                .opacity(txtSearch.isEmpty ? 0.0 : 1.0)
                                .onTapGesture {
                                    txtSearch = ""
                                }
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                                .opacity(txtSearch.isEmpty ? 1.0 : 0.0)
                                .padding(.horizontal)
                        }
                    }
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(filteredProducts) { index in
                            NavigationLink {
                                ProductDetailView(product: index)
                            } label: {
                                ProductSearchCard(product: index)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("Search")
            .onAppear {
                vm.fetchProducts()
            }
        }
    }
}
