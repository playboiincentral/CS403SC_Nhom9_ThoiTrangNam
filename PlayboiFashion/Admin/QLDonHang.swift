//
//  QLDonHang.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct QLDonHang: View {
    @EnvironmentObject var vm: ViewModel
    @State private var hasLoaded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Quản lý đơn hàng")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    Spacer()
                } .padding()
                List {
                    if vm.orders.isEmpty {
                        Text("No orders yet.")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        ForEach(vm.orders) { order in
                            NavigationLink {
                                QLDonHangCT(order: order)
                            } label: {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("👤 \(order.fullname)")
                                        .font(.headline)
                                    Text("📞 \(order.phonenumber ?? "No phone")")
                                    Text("🕒 \(order.createdAt.formatted(date: .abbreviated, time: .shortened))")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                    Text("💰 \(Int(order.total))đ")
                                        .font(.subheadline)
                                    Text("📦 Status: \(order.status.capitalized)")
                                        .font(.subheadline)
                                        .foregroundColor(color(for: order.status))
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .onAppear {
                    if !hasLoaded {
                        vm.fetchOrder()
                        hasLoaded = true
                    }
                }
            }
        }
    }
}

func color(for status: String) -> Color {
    switch status {
    case "pending":
        return .orange
    case "confirmed":
        return .blue
    case "shipping":
        return .purple
    case "delivered":
        return .green
    case "cancelled":
        return .red
    default:
        return .gray
    }
}
