//
//  ProfileView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/6/25.
//

import SwiftUI

struct ProfileView: View {
    let countries = [" 🇺🇸 +1","🇻🇳 +84"]
    @State private var selectedCountry = "🇻🇳 +84"
    @EnvironmentObject private var vm: ViewModel
    @State private var isEditingName = false
    @State private var isEditingPhone = false
    @State private var isEditingAddress = false
    
    @State private var newName: String = ""
    @State private var newPhone: String = ""
    @State private var newAddress: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("👤 User Profile")
                .font(.largeTitle)
                .bold()
            
            Group {
                HStack {
                    Text("Email:")
                        .bold()
                    Spacer()
                    Text(vm.currentUser?.email ?? "")
                }
                
                // Name
                HStack {
                    Text("Name:")
                        .bold()
                    Spacer()
                    if isEditingName {
                        TextField("Enter name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        Button("Save") {
                            vm.updateProfileField(field: "fullname", value: newName)
                            vm.currentUser?.fullname = newName
                            isEditingName = false
                        }
                    } else {
                        Text(vm.currentUser?.fullname ?? "")
                        Button("Edit") {
                            newName = vm.currentUser?.fullname ?? ""
                            isEditingName = true
                        }
                    }
                }
                
                // Phone
                HStack {
                    Text("Phone:")
                        .bold()
                    Spacer()
                    if isEditingPhone {
                        TextField("Enter phone", text: $newPhone)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        Button("Save") {
                            vm.updateProfileField(field: "phonenumber", value: newPhone)
                            vm.currentUser?.phonenumber = newPhone
                            isEditingPhone = false
                        }
                    } else {
                        Text(vm.currentUser?.phonenumber ?? "No phone")
                        Button("Edit") {
                            newPhone = vm.currentUser?.phonenumber ?? ""
                            isEditingPhone = true
                        }
                    }
                }
                
                // Address
                HStack {
                    Text("Address:")
                        .bold()
                    Spacer()
                    if isEditingAddress {
                        TextField("Enter address", text: $newAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                        Button("Save") {
                            vm.updateProfileField(field: "address", value: newAddress)
                            vm.currentUser?.address = newAddress
                            isEditingAddress = false
                        }
                    } else {
                        Text(vm.currentUser?.address ?? "No address")
                        Button("Edit") {
                            newAddress = vm.currentUser?.address ?? ""
                            isEditingAddress = true
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

struct DoneButton: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Text("Done")
                .font(.title2)
                .foregroundStyle(.white)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 27)
                        .fill(.black)
                )
        }
        
    }
}

#Preview {
    ProfileView()
}
