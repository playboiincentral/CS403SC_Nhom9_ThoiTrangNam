//
//  CheckOutView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/20/25.
//

import SwiftUI

struct CheckOutView: View {
    let selectedItems: [CartItem]
    let quantities: [String: Int]
    let totalPrice: Double
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: ViewModel
    @State private var note: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isSuccess = false
    
    var userAddress: String {
        vm.currentUser?.address ?? "No address saved"
    }
    
    var userPhone: String {
        vm.currentUser?.phonenumber ?? "No phone number"
    }
    
    let shippingFee: Double = 50000
    
    var finalTotal: Double {
        totalPrice + shippingFee
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Checkout")
                .font(.largeTitle)
                .bold()
                .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Danh sách sản phẩm
                    ForEach(selectedItems, id: \.id) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.productName)
                                    .font(.headline)
                                Text("Size: \(item.selectedSize)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Quantity: \(quantities[item.id] ?? 1)")
                            }
                            Spacer()
                            Text("\(Int(item.price * Double(quantities[item.id] ?? 1)))đ")
                        }
                        Divider()
                    }
                    
                    // Phí ship
                    HStack {
                        Text("Shipping Fee:")
                            .font(.headline)
                        Spacer()
                        Text("+\(Int(shippingFee))đ")
                            .font(.subheadline)
                    }
                    
                    // Tổng cộng
                    HStack {
                        Text("Total to Pay:")
                            .font(.headline)
                        Spacer()
                        Text("\(Int(finalTotal))đ")
                            .font(.title3)
                            .bold()
                    }
                    
                    // Giao hàng và thanh toán
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Delivery Information")
                            .font(.headline)
                        
                        HStack {
                            Image(systemName: "location.fill")
                            Text(userAddress)
                        }
                        
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(userPhone)
                        }
                        
                        HStack {
                            Image(systemName: "banknote.fill")
                            Text("Payment on delivery (Cash)")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    // Ghi chú
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Note for the shop (optional):")
                            .font(.headline)
                        TextField("Enter your note here...", text: $note, axis: .vertical)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            
            // Nút quay lại và xác nhận
            HStack(spacing: 20) {
                Button {
                    dismiss()
                } label: {
                    Text("Back to Cart")
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                
                Button {
                    Task {
                        do {
                            try await vm.confirmOrder(
                                items: selectedItems,
                                quantities: quantities,
                                total: finalTotal,
                                note: note
                            )
                            alertMessage = "Order Successful!"
                            isSuccess = true
                            showAlert = true
                        } catch {
                            alertMessage = error.localizedDescription
                            isSuccess = false
                            showAlert = true
                        }
                    }
                } label: {
                    Text("Confirm Order")
                        .font(.title3)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .alert(alertMessage, isPresented: $showAlert) {
                    Button("OK") {
                        if isSuccess {
                            dismiss()
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}
