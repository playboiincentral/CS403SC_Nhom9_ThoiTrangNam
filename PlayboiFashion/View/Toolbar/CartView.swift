//
//  CartView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/19/25.
//

import SwiftUI

struct CartView: View {
    @EnvironmentObject private var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedItems: Set<String> = [] // chứa ID các item được chọn
    @State private var quantities: [String: Int] = [:] // key: cartItem.id, value: quantity
    @State private var showCheckout = false
    @State private var showNoSelectionAlert = false
    
    var selectedCartItems: [CartItem] {
        vm.cartItems.filter { selectedItems.contains($0.id) }
    }
    
    var totalPrice: Double {
        vm.cartItems.reduce(0) { result, item in
            if selectedItems.contains(item.id) {
                let quantity = quantities[item.id] ?? 1
                return result + item.price * Double(quantity)
            } else {
                return result
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            if vm.cartItems.isEmpty {
                VStack {
                    Image("cart")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .scaledToFill()
                    Text("There's no product here!")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                    Text("Shop now and enjoy our best deals with huge discounts automatically applied to your items!")
                        .font(.body)
                        .fontWeight(.medium)
                    Button {
                        vm.selectedTab = 1
                        dismiss()
                    } label: {
                        Text("SHOP NOW")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .padding()
                            .padding(.horizontal, 60)
                            .background(
                                Rectangle()
                                    .fill(.black)
                            )
                    }
                }
                .navigationTitle("🛒 CART")
                .navigationBarTitleDisplayMode(.inline)
            } else {
                List {
                    ForEach(vm.cartItems) { item in
                        HStack(alignment: .top, spacing: 12) {
                            // Checkbox
                            Button(action: {
                                if selectedItems.contains(item.id) {
                                    selectedItems.remove(item.id)
                                } else {
                                    selectedItems.insert(item.id)
                                }
                            }) {
                                Image(systemName: selectedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(.blue)
                            }
                            
                            // Hình ảnh
                            if let firstImageURL = item.imgs.first, let url = URL(string: firstImageURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 60, height: 60)
                                .cornerRadius(8)
                            }
                            
                            // Thông tin
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.productName)
                                    .font(.headline)
                                Text("Size: \(item.selectedSize)")
                                Text("Price: \(Int(item.price))đ")
                                
                                // Picker số lượng
                                Picker("Quantity:", selection: Binding(
                                    get: { quantities[item.id] ?? 1 },
                                    set: { quantities[item.id] = $0 }
                                )) {
                                    ForEach(1..<11) { qty in
                                        Text("\(qty)").tag(qty)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(width: 100)
                            }
                            
                            Spacer()
                            
                            // Nút xoá
                            Button(role: .destructive) {
                                vm.deleteCartItem(item)
                                selectedItems.remove(item.id)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle()) // <- rất quan trọng
                            
                        }
                        .padding(.vertical, 6)
                    }
                }
                // Tổng tiền & nút thanh toán
                VStack {
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(totalPrice))đ")
                            .font(.title3)
                            .bold()
                    }
                    .padding(.horizontal)
                    Button {
                        if selectedItems.isEmpty {
                            showNoSelectionAlert = true
                        } else {
                            showCheckout = true
                        }
                    } label: {
                        Text("Check Out")
                            .font(.title3)
                            .foregroundStyle(.white)
                            .fontWeight(.semibold)
                            .padding()
                            .padding(.horizontal, 40)
                            .background(
                                RoundedRectangle(cornerRadius: 25.0)
                                    .foregroundStyle(.black)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .navigationTitle("🛒 CART")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Please select at least one product to checkout.", isPresented: $showNoSelectionAlert) {
                    Button("OK", role: .cancel) { }
                }
                .fullScreenCover(isPresented: $showCheckout) {
                    CheckOutView(
                        selectedItems: selectedCartItems,
                        quantities: quantities,
                        totalPrice: totalPrice
                    )
                }
            }
        }
    }
}

#Preview {
    CartView()
}
