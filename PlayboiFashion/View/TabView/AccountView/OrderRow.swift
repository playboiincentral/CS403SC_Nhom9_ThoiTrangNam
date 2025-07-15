//
//  OrderRow.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/22/25.
//

import SwiftUI

struct OrderRow: View {
    let order: Order
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("🛒 Mã đơn: \(order.id.prefix(8))")
                .font(.headline)
            Text("🕒 \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("💰 Tổng tiền: \(Int(order.total))đ")
                .font(.subheadline)
            Text("📦 Trạng thái: \(order.status.capitalized)")
                .foregroundColor(color(for: order.status))
        }
        .padding(.vertical, 4)
    }
    
    func color(for status: String) -> Color {
        switch status {
        case "pending": return .orange
        case "confirmed": return .blue
        case "shipping": return .purple
        case "delivered": return .green
        case "cancelled": return .red
        default: return .gray
        }
    }
}
