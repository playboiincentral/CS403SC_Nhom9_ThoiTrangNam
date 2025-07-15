//
//  ContentView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var vm: ViewModel
    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoggedIn {
                    if vm.isProfileSetupDone {
                        if vm.currentUser?.role == 1 {
                            HomeTabView()
                                .tint(.black)
                        } else {
                            AdminView()
                                .tint(.black)
                        }
                    } else {
                        ProfileCompletionView()
                    }
                } else {
                    SplashScreen()
                }
            }
            .onAppear {
                // Kiểm tra trạng thái đăng nhập khi app khởi động
                vm.checkUserStatus()
            }
        }
    }
}

struct HomeTabView: View {
    @EnvironmentObject private var vm: ViewModel
    var body: some View {
        TabView(selection: $vm.selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            CategoryView()
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Category")
                }
                .tag(1)
            
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Account")
                }
                .tag(2)
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("Playboi Fashion")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
            }
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    NavigationLink {
                        SearchView()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.black)
                    }
                    NavigationLink {
                        CartView()
                    } label: {
                        Image(systemName: "cart")
                            .foregroundStyle(.black)
                    }
                }
                
            }
        }
    }
}

#Preview {
    ContentView()
}
