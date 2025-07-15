//
//  ThongKeDoanhThu.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct ThongKeDoanhThu: View {
    @EnvironmentObject var vm: ViewModel

    @State private var fromDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
    @State private var toDate = Date()

    var filteredOrders: [Order] {
        vm.orders.filter {
            $0.status == "delivered" &&
            $0.createdAt >= fromDate &&
            $0.createdAt <= toDate
        }
    }

    var totalRevenue: Int {
        filteredOrders.reduce(0) { result, order in
            result + Int(order.total)
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("📊 THỐNG KÊ DOANH THU")
                    .font(.title)
                    .fontWeight(.bold)

                // Bộ lọc ngày
                VStack(spacing: 16) {
                    DatePicker("Từ ngày", selection: $fromDate, displayedComponents: .date)
                    DatePicker("Đến ngày", selection: $toDate, in: fromDate...Date(), displayedComponents: .date)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.1)))
                .padding(.horizontal)

                // Doanh thu
                VStack(spacing: 12) {
                    HStack {
                        Text("🛍️ Số đơn đã giao:")
                        Spacer()
                        Text("\(filteredOrders.count) đơn")
                            .bold()
                    }

                    HStack {
                        Text("💰 Doanh thu:")
                        Spacer()
                        Text("\(totalRevenue.formattedWithSeparator()) đ")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.green)
                    }

                    if let latest = filteredOrders.map(\.createdAt).max() {
                        HStack {
                            Text("🕒 Mới nhất:")
                            Spacer()
                            Text(latest.formatted(date: .abbreviated, time: .shortened))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(.gray.opacity(0.05)))
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .onAppear {
                vm.fetchOrder()
            }
        }
    }
}

#Preview {
    ThongKeDoanhThu()
}
