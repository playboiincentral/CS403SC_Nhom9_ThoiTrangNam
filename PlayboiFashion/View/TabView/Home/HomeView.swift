//
//  HomeView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView (.vertical, showsIndicators: false){
                VStack (spacing: 30) {
                    Banner()
                    CategorySelection()
                        .padding(.top)
                    BrandSelection()
                        .padding(.top, 30)
                    Spacer()
                }
            }
        }
    }
}

struct CategorySelection: View {
    let types = [
        ("tshirt", "tshirt", "T-shirt"),
        ("jacket", "jacket", "Jacket"),
        ("hat", "hat.cap", "Hat"),
        ("sunglasses", "sunglasses", "Sunglasses"),
        ("watch", "watch.analog", "Watch"),
        ("backpack", "backpack", "Backpack"),
        ("shoes", "shoe.2", "Shoes"),
        ("wallet", "wallet.bifold", "Wallet")
    ]
    let categoryColumns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    var body: some View {
        LazyVGrid(columns: categoryColumns, spacing: 30) {
            ForEach(types, id: \.0) { index in
                NavigationLink {
                    ProductListView(filter: .type(index.0))
                } label: {
                    IconCategory(displayImg: index.1, displayName: index.2)
                }
            }
        }
    }
}

struct BrandSelection: View {
    let brands = [
        ("dickies", "dickies"),
        ("bhpc", "beverly_hills_polo_club"),
        ("charles_tyrwhitt", "charles_tyrwhitt"),
        ("daniel_wellington", "daniel_wellington"),
        ("dsquared2", "dsquared2"),
        ("on_running", "on_running")
    ]
    let brandColumns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    var body: some View {
        VStack (spacing: 5) {
            HStack {
                Text("Brand Selection")
                    .font(.title)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                Spacer()
            } .padding(.horizontal, 10)
            LazyVGrid(columns: brandColumns, spacing: 5) {
                ForEach(brands, id: \.0) {
                    index in
                    NavigationLink {
                        ProductListView(filter: .brand(index.0))
                    } label: {
                        Image(index.1)
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
