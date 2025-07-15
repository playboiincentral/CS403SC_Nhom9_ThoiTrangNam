//
//  SignUpView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: ViewModel
    @State private var showAlert = false
    private var alert: Alert {
        Alert(title: Text("Alert"), message: Text(vm.errorMessage), dismissButton: .default(Text("OK")))
    }
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Sign Up")
                    .font(.title)
                    .bold()
                Text("Create your account to explore Playboi Fashion")
                    .font(.headline)
                    .fontWeight(.thin)
            }
            VStack(alignment: .leading, spacing:6) {
                Text("Email Address")
                    .font(.headline)
                    .fontWeight(.medium)
                TextField("Type your email address...", text: $vm.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Password")
                    .font(.headline)
                    .fontWeight(.medium)
                SecureField("Type your password...", text: $vm.password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Fullname")
                    .font(.headline)
                    .fontWeight(.medium)
                TextField("Type your fullname...", text: $vm.fullname)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
            }
            Button {
                vm.register()
                if !vm.errorMessage.isEmpty {
                    showAlert = true
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundStyle(.black)
                    )
            }
        } //VStack
        .padding()
        .onChange(of: vm.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                dismiss()
            }
        }
        .alert(isPresented: $showAlert) {
            alert
        }
    }
}

#Preview {
    SignUpView()
}
