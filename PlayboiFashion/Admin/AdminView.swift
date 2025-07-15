//
//  AdminView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/20/25.
//

import SwiftUI

struct AdminView: View {
    @EnvironmentObject private var vm: ViewModel
    var body: some View {
        TabView {
            QLTaiKhoan()
                .tabItem {
                    Image(systemName: "person.text.rectangle.fill")
                    Text("QLTK")
                }
                .tag(0)
            QLSanPham()
                .tabItem {
                    Image(systemName: "tshirt.circle.fill")
                    Text("QLSP")
                }
                .tag(1)
            QLDonHang()
                .tabItem {
                    Image(systemName: "cart.badge.clock.fill")
                    Text("QLDH")
                }
                .tag(2)
            ThongKeDoanhThu()
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("TKDT")
                }
                .tag(3)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.logout()
                } label: {
                    Text("Log out")
                        .font(.headline)
                        .foregroundStyle(.red)
                }

            }
        }
    }
}

#Preview {
    AdminView()
}
