//
//  ProfileCompletionView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/23/25.
//

import SwiftUI

struct ProfileCompletionView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var phone: String = ""
    @State private var address: String = ""

    var isFormComplete: Bool {
        !phone.trimmingCharacters(in: .whitespaces).isEmpty &&
        !address.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Complete Your Profile")
                .font(.title)
                .bold()

            TextField("Phone Number", text: $phone)
                .keyboardType(.phonePad)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Address", text: $address)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                vm.updateProfileField(field: "phonenumber", value: phone)
                vm.updateProfileField(field: "address", value: address)

                // Cập nhật local user để trigger isProfileComplete
                vm.currentUser?.phonenumber = phone
                vm.currentUser?.address = address
                vm.isProfileSetupDone = true
            }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormComplete ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(!isFormComplete)

            Spacer()
        }
        .padding()
        .onAppear {
            phone = vm.phonenumber
            address = vm.address
        }
    }
}

#Preview {
    ProfileCompletionView()
}
