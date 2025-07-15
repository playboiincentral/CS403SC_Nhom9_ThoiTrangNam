//
//  PhoneNumberInputView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct PhoneNumberInputView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var phone: String = ""
    @State private var isNextActive = false

    var body: some View {
        VStack(spacing: 24) {
            Text("📱 Let's type your phone number...")
                .font(.title2).bold()

            TextField("Phone number", text: $phone)
                .keyboardType(.phonePad)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            Spacer()

            HStack {
                Spacer()
                if !phone.isEmpty {
                    Button("Next") {
                        vm.updateProfileField(field: "phonenumber", value: phone)
                        isNextActive = true
                    }
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $isNextActive) {
            AddressInputView()
        }
    }
}

//#Preview {
//    PhoneNumberInputView()
//}
