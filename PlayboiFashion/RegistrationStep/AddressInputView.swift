//
//  AddressInputView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct AddressInputView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var address: String = ""
    @State private var isDone = false

    var body: some View {
        VStack(spacing: 24) {
            Text("🏠 Type your address to delivering")
                .font(.title2).bold()

            TextField("Address", text: $address)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)

            Spacer()

            HStack {
                Spacer()
                if !address.isEmpty {
                    Button("Done") {
                        vm.updateProfileField(field: "address", value: address)
                        isDone = true
                    }
                    .padding()
                    .background(.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationDestination(isPresented: $isDone) {
            HomeView()
        }
    }
}


#Preview {
    AddressInputView()
}
