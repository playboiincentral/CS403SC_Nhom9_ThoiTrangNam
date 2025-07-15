//
//  QLDonHangCT.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/21/25.
//

import SwiftUI

struct QLDonHangCT: View {
    @EnvironmentObject private var vm: ViewModel
    let order: Order
    @State private var showCancelAlert = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Customer Info")
                    .font(.title3)
                    .bold()
                Text("👤 \(order.fullname)")
                Text("📧 \(order.email)")
                Text("📞 \(order.phonenumber ?? "No phone")")
                Text("🏠 \(order.address ?? "No address")")
                Text("📝 Note: \(order.note.isEmpty ? "None" : order.note)")
                Text("🕒 Ordered: \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")
                
                Divider().padding(.vertical, 8)
                
                Text("Products")
                    .font(.title3)
                    .bold()
                
                ForEach(order.items, id: \.id) { item in
                    HStack(alignment: .top, spacing: 12) {
                        // Hình ảnh sản phẩm
                        if let firstImg = item.imgs.first, let url = URL(string: firstImg) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                        }
                        
                        // Thông tin sản phẩm
                        VStack(alignment: .leading, spacing: 4) {
                            Text("🛍️ \(item.productName)")
                                .font(.headline)
                            Text("Size: \(item.selectedSize)")
                            Text("Quantity: \(order.quantities[item.id] ?? 1)")
                            Text("Subtotal: \(Int(item.price * Double(order.quantities[item.id] ?? 1)))đ")
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                    Divider()
                }
                
                HStack {
                    Spacer()
                    Text("TOTAL: \(Int(order.total))đ")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding(.top)
                if order.status == "pending" {
                    HStack {
                        Button("✅ Xác nhận đơn") {
                            vm.updateOrderStatus(orderID: order.id, to: "confirmed")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("❌ Huỷ đơn") {
                            vm.updateOrderStatus(orderID: order.id, to: "cancelled")
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .alert("Bạn có chắc muốn huỷ đơn này?", isPresented: $showCancelAlert) {
                            Button("Huỷ đơn", role: .destructive) {
                                vm.updateOrderStatus(orderID: order.id, to: "cancelled")
                            }
                            Button("Không", role: .cancel) { }
                        }
                    }
                } else if order.status == "confirmed" {
                    Button("🚚 Bắt đầu giao hàng") {
                        vm.updateOrderStatus(orderID: order.id, to: "shipping")
                    }
                    .buttonStyle(.bordered)
                    .tint(.purple)
                } else if order.status == "shipping" {
                    Button("🚚 Đã giao hàng") {
                        vm.updateOrderStatus(orderID: order.id, to: "delivered")
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }
                
            }
            .padding()
        }
        .navigationTitle("Order Details")
    }
}
