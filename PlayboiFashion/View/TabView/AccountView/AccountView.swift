//
//  AccountView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/7/25.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject private var vm: ViewModel
    let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                NavigationLink {
                    ProfileView()
                } label: {
                    ProfileCard(fullname: vm.currentUser?.fullname)
                        .foregroundStyle(.black)
                }
                .padding()
                LazyVGrid(columns: columns, spacing: 30) {
                    NavigationLink {
                        OrderView()
                    } label: {
                        OrderCard()
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        ChatCard()
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    
                    NavigationLink {
                        
                    } label: {
                        PolicyCard()
                            .font(.title)
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                    }
                    
                }
                .padding()
                Divider()
                    .padding(.top)
                LogOutButton()
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .padding()
                VStack (alignment: .leading, spacing: 10) {
                    Text("Playboi Fashion Retail Management International Joint Stock Company")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                    VStack (alignment: .leading, spacing: 10) {
                        Text("Address: 543 Nguyen Tat Thanh, Thanh Khe District, Da Nang city.")
                        Text("Email: playboiincentral@gmail.com")
                        Text("Hotline: 1900 123 456")
                    } .font(.body)
                        .foregroundStyle(.black)
                        .fontWeight(.thin)
                } .padding()
            }
        }
    }
}

struct ProfileCard: View {
    let fullname: String?
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Hi,")
                Text(fullname ?? "")
                    .font(.title2)
                    .fontWeight(.semibold)
                HStack {
                    Text("member of")
                    Text("Playboi Fashion")
                        .fontWeight(.semibold)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.white)
                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
        )
    }
}

struct OrderCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "truck.box")
            Text("Order")
        } .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
            )
    }
}

struct ChatCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "ellipsis.message")
            Text("Chat")
        } .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
            )
    }
}

struct PolicyCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "info.circle")
            Text("Policy")
        } .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(.white)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 4)
            )
    }
}

struct LogOutButton: View {
    @EnvironmentObject private var vm: ViewModel
    var body: some View {
        Button {
            vm.logout()
        } label: {
            HStack {
                Image(systemName: "person.circle")
                Text("Log out")
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
            }
            .font(.title3)
            .fontWeight(.bold)
        }
    }
}


#Preview {
    AccountView()
}
