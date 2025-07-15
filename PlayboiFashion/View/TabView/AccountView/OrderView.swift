//
//  OrderView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/8/25.
//

import SwiftUI

struct OrderView: View {
    @EnvironmentObject var vm: ViewModel
    
    var processingOrders: [Order] {
        vm.orders.filter { $0.status == "pending" || $0.status == "confirmed" || $0.status == "shipping"}
    }
    
    var completedOrders: [Order] {
        vm.orders.filter { $0.status == "delivered" || $0.status == "cancelled" }
    }
    
    var body: some View {
        NavigationStack {
            List {
                // PHẦN 1: ĐANG XỬ LÝ
                Section(header: Text("📦 Đang xử lý").font(.headline)) {
                    if processingOrders.isEmpty {
                        Text("Không có đơn nào.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(processingOrders) { order in
                            NavigationLink {
                                OrderInformation(order: order)
                            } label: {
                                OrderRow(order: order)
                            }
                        }
                    }
                }
                
                // PHẦN 2: HOÀN TẤT
                Section(header: Text("✅ Hoàn tất").font(.headline)) {
                    if completedOrders.isEmpty {
                        Text("Chưa có đơn hoàn tất.")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(completedOrders) { order in
                            NavigationLink {
                                OrderInformation(order: order)
                            } label: {
                                OrderRow(order: order)
                            }
                        }
                    }
                }
            }
            .navigationTitle("MY ORDER")
            .onAppear {
                vm.fetchOrderForCurrentUser()
            }
        }
    }
}

#Preview {
    OrderView()
}
