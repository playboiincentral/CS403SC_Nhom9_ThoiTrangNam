//
//  QLSanPham.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct QLSanPham: View {
    @EnvironmentObject private var vm: ViewModel
    @State private var showingForm = false
    @State private var editingProduct: Product? = nil
    @State private var hasLoaded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Quản lý sản phẩm")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        editingProduct = nil
                        showingForm = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(.black)
                    }
                } .padding()
                List {
                    ForEach(vm.products) { product in
                        VStack(alignment: .leading) {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(product.imgs, id: \.self) { img in
                                        AsyncImage(url: URL(string: img)) { image in
                                            image.resizable().scaledToFill()
                                        } placeholder: {
                                            Color.gray
                                        }
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(8)
                                    }
                                }
                            }
                            
                            Text("Tên: \(product.name)").bold()
                            Text("Giá: \(product.price, specifier: "%.0f") đ")
                            Text("Hãng: \(product.brandID)")
                            Text("Loại: \(product.typeID)")
                            if !product.sizes.isEmpty {
                                Text("Sizes:")
                                ForEach(product.sizes, id: \.self) { size in
                                    Text("- \(size.size): \(size.quantity) cái")
                                        .font(.caption)
                                }
                            }

                            HStack {
                                Button("✏️ Sửa") {
                                    editingProduct = product
                                    showingForm = true
                                }
                                .buttonStyle(PlainButtonStyle()) // <- rất quan trọng
                                .foregroundColor(.blue)
                                
                                Button("🗑 Xoá") {
                                    vm.deleteProduct(product)
                                }
                                .buttonStyle(PlainButtonStyle()) // <- rất quan trọng
                                .foregroundColor(.red)
                            }
                            .padding(.top, 5)
                        }
                        .padding(.vertical, 10)
                    }
                }
                .onAppear {
                    if !hasLoaded {
                        vm.fetchProducts()
                        hasLoaded = true
                    }
                }
            } //VStack
            .sheet(isPresented: $showingForm) {
                ProductFormView(product: editingProduct) { newProduct in
                    if let _ = editingProduct {
                        vm.updateProduct(newProduct)
                    } else {
                        vm.addProduct(newProduct)
                    }
                }
            }
        }
    }
}

struct ProductFormView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var id: String = UUID().uuidString
    @State var name: String = ""
    @State var price: String = ""
    @State var imgsInput: String = ""
    @State var brandID: String = ""
    @State var typeID: String = ""
    @State var sizes: [SizeStock] = []

    @State private var newSize: String = ""
    @State private var newQuantity: String = ""
    
    var product: Product?
    var onSave: (Product) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Thông tin cơ bản")) {
                    TextField("Tên sản phẩm", text: $name)
                    TextField("Giá", text: $price)
                        .keyboardType(.decimalPad)
                    TextField("Ảnh (URL, cách nhau bằng dấu phẩy)", text: $imgsInput)
                    TextField("Mã hãng", text: $brandID)
                    TextField("Mã loại", text: $typeID)
                }

                Section(header: Text("Size & Số lượng")) {
                    HStack {
                        TextField("Size (VD: M)", text: $newSize)
                        TextField("Số lượng", text: $newQuantity)
                            .keyboardType(.numberPad)
                        Button(action: {
                            guard !newSize.isEmpty,
                                  let quantity = Int(newQuantity)
                            else { return }

                            sizes.append(SizeStock(size: newSize, quantity: quantity))
                            newSize = ""
                            newQuantity = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }

                    ForEach(sizes, id: \.self) { item in
                        HStack {
                            Text("Size \(item.size)")
                            Spacer()
                            Text("Số lượng: \(item.quantity)")
                        }
                    }
                    .onDelete { indexSet in
                        sizes.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationTitle(product == nil ? "Thêm sản phẩm" : "Sửa sản phẩm")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Huỷ") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Lưu") {
                        guard let priceValue = Double(price) else { return }

                        let imgArray = imgsInput
                            .split(separator: ",")
                            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

                        let newProduct = Product(
                            id: product?.id ?? UUID().uuidString,
                            name: name,
                            price: priceValue,
                            imgs: imgArray,
                            brandID: brandID,
                            typeID: typeID,
                            sizes: sizes
                        )

                        onSave(newProduct)
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let product = product {
                id = product.id
                name = product.name
                price = String(product.price)
                imgsInput = product.imgs.joined(separator: ", ")
                brandID = product.brandID
                typeID = product.typeID
                sizes = product.sizes
            }
        }
    }
}
