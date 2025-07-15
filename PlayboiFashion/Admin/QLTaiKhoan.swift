//
//  QLTaiKhoan.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct QLTaiKhoan: View {
    @EnvironmentObject private var vm: ViewModel
    @State private var hasLoaded = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Quản lý tài khoản")
                        .font(.title2)
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                    Spacer()
                } .padding()
                List {
                    ForEach(vm.users) { user in
                        VStack(alignment: .leading, spacing: 5) {
                            // Thông tin user
                            Text("👤 \(user.fullname)").bold()
                            Text("📧 \(user.email)")
                            if let phone = user.phonenumber {
                                Text("📱 \(phone)")
                            }
                            if let addr = user.address {
                                Text("🏠 \(addr)")
                            }
                            Text("🛡 Vai trò: \(user.role == 1 ? "Khách hàng" : "Admin")")
                            
                            // Nút hành động
                            HStack {
                                Button(action: {
                                    let newRole = user.role == 1 ? 0 : 1
                                    vm.updateUserRole(user: user, to: newRole)
                                }) {
                                    Text("🔁 Đổi vai trò")
                                        .foregroundColor(.blue)
                                }
                                .buttonStyle(PlainButtonStyle()) // <- rất quan trọng
                                
                                Button(action: {
                                    vm.deleteUser(user)
                                }) {
                                    Text("🗑 Xoá")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle()) // <- rất quan trọng
                            }
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 6)
                        .contentShape(Rectangle()) // <- tránh bị tap toàn dòng
                    }
                }
                .onAppear {
                    if !hasLoaded {
                        vm.fetchUsers()
                        hasLoaded = true
                    }
                }
            }
        }
    }
}

#Preview {
    QLTaiKhoan()
}
