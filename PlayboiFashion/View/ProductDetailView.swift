//
//  ProductDetailView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 5/6/25.
//

import SwiftUI

struct ProductDetailView: View {
    @EnvironmentObject private var vm: ViewModel
    let product: Product
    var sizes: [String] {
        if product.typeID.contains("backpack") || product.typeID.contains("hat") || product.typeID.contains("watch") || product.typeID.contains("sunglasses") || product.typeID.contains("wallet") {
            return ["NO SIZE"]
        } else if product.typeID.contains("shoes") {
            return ["38", "39", "40", "40.5", "41", "41.5", "42", "42.5", "43", "43.5", "44", "44.5", "45"]
        } else {
            return ["S", "M", "L", "XL"]
        }
    }
    
    let columns = [
        GridItem(.adaptive(minimum: 75), spacing: 12)
    ]
    
    @State private var showAlert = false
    @State private var selectedSize: String? = nil
    
    private var alert: Alert {
        Alert(
            title: Text("Lưu ý"),
            message: Text(vm.alertMessage ?? ""),
            dismissButton: .default(Text("OK"))
        )
    }
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    ProductTabView(product: product)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text(product.brandID)
                            .fontWeight(.semibold)
                        Text(product.name)
                            .fontWeight(.light)
                        Text("\(product.price, specifier: "%.0f") vnđ")
                            .fontWeight(.bold)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text("SIZE")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                Spacer()
                                Text("Size guide")
                                    .fontWeight(.semibold)
                                    .underline()
                            }
                            
                            LazyVGrid(columns: columns, spacing: 12) {
                                ForEach(sizes, id: \.self) { size in
                                    Button {
                                        selectedSize = size
                                    } label: {
                                        Text(size)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(selectedSize == size ? .white : .black)
                                            .background(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .foregroundStyle(selectedSize == size ? .black : .gray.opacity(0.2))
                                            )
                                    }
                                }
                            }
                        }
                    }
                    .foregroundStyle(.black)
                    .padding()
                    VStack(alignment: .leading, spacing: 6) {
                        Text("RELATED PRODUCTS")
                            .font(.title2)
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .padding(.leading)
                        RelatedSection()
                    }
                    Spacer()
                }
            }
            
            VStack {
                Spacer()
                Button {
                    guard let size = selectedSize else {
                        vm.alertMessage = "Bạn hãy chọn size."
                        showAlert = true
                        return
                    }
                    
                    guard let userID = vm.currentUser?.id else {
                        vm.alertMessage = "Không tìm thấy tài khoản người dùng."
                        showAlert = true
                        return
                    }
                    
                    vm.addToCart(product: product, selectedSize: size, userID: userID)
                    vm.alertMessage = "Thêm vào giỏ hàng thành công!"
                    
                    if vm.alertMessage != nil {
                        showAlert = true
                    }
                } label: {
                    Image(systemName: "cart.badge.plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(40)
                }
                .padding(.horizontal, 50)
                .alert(isPresented: $showAlert, content: {
                    alert
                })
            }
        }
    }
}

struct ProductTabView: View {
    let product: Product
    @State private var selectedImageIndex = 0
    var body: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(product.imgs.indices, id: \.self) { index in
                AsyncImage(url: URL(string: product.imgs[index])) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: .infinity)
        .frame(height: 500)
    }
}

struct RelatedSection: View {
    @EnvironmentObject private var vm: ViewModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(vm.products) { index in
                    NavigationLink {
                        ProductDetailView(product: index)
                    } label: {
                        RelatedProductCard(product: index)
                    }
                }
            }
        }
    }
}
