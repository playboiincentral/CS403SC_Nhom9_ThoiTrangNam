//
//  OrderInformation.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/22/25.
//

import SwiftUI

struct OrderInformation: View {
    let order: Order

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Thông tin người mua
                Text("🧾 Thông tin đơn hàng")
                    .font(.title3).bold()
                Text("👤 Tên: \(order.fullname)")
                Text("📞 SĐT: \(order.phonenumber ?? "Chưa có")")
                Text("🏠 Địa chỉ: \(order.address ?? "Chưa có")")
                Text("📦 Trạng thái: \(order.status.capitalized)")
                    .foregroundColor(color(for: order.status))
                Text("📝 Ghi chú: \(order.note.isEmpty ? "Không có" : order.note)")
                Text("🕒 Thời gian: \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")

                Divider().padding(.vertical, 6)

                // Danh sách sản phẩm
                Text("🛍️ Sản phẩm đã đặt")
                    .font(.title3).bold()

                ForEach(order.items, id: \.id) { item in
                    HStack(alignment: .top, spacing: 12) {
                        if let img = item.imgs.first, let url = URL(string: img) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 70, height: 70)
                            .cornerRadius(8)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.productName)
                                .font(.headline)
                            Text("Size: \(item.selectedSize)")
                            Text("Số lượng: \(order.quantities[item.id] ?? 1)")
                            Text("Tạm tính: \(Int(item.price * Double(order.quantities[item.id] ?? 1)))đ")
                        }
                        Spacer()
                    }
                    Divider()
                }

                // Tổng tiền
                HStack {
                    Spacer()
                    Text("TỔNG CỘNG: \(Int(order.total))đ")
                        .font(.title2).bold()
                    Spacer()
                }
                .padding(.top)
            }
            .padding()
        }
        .navigationTitle("Chi tiết đơn hàng")
    }

    func color(for status: String) -> Color {
        switch status {
        case "pending": return .orange
        case "confirmed": return .blue
        case "delivered": return .green
        case "cancelled": return .red
        default: return .gray
        }
    }
}


//#Preview {
//    OrderInformation()
//}
