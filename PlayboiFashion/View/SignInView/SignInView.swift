//
//  SignInView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: ViewModel
    @State private var showAlert: Bool = false
    private var alert: Alert {
        Alert(
            title: Text("Alert"),
            message: Text(vm.errorMessage),
            dismissButton: .default(Text("OK"))
        )
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Login")
                    .font(.title)
                    .bold()
                Text("Welcome to the Playboi Fashion app")
                    .font(.headline)
                    .fontWeight(.light)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Email Address")
                    .font(.headline)
                    .fontWeight(.medium)
                TextField("Type your email address...", text: $vm.email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
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
            Button {
                vm.login()
                if !vm.errorMessage.isEmpty {
                    showAlert = true
                }
            } label: {
                Text("Login")
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
        }
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
    SignInView()
}
