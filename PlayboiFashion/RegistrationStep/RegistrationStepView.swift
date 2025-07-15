//
//  RegistrationStepView.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct RegistrationStepView: View {
    @EnvironmentObject private var vm: ViewModel
    
    var body: some View {
        Group {
            switch vm.registrationStep {
            case .phonenumber:
                PhoneNumberInputView()
            case .address:
                AddressInputView()
            case .done:
                HomeTabView()
            default:
                PhoneNumberInputView()
            }
        }
        .animation(.easeInOut, value: vm.registrationStep)
        .transition(.slide)
    }
}
