//
//  SplashScreen.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 6/17/25.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Image("playboifashion_wallpaper")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 12) {
                Spacer()
                Text("Playboi Fashion")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Street vibes. Playboi style.")
                    .font(.title2)
                    .fontWeight(.medium)
                HStack {
                    NavigationLink {
                        SignUpView()
                    } label: {
                        Text("Sign Up")
                            .foregroundStyle(.black)
                            .fontWeight(.bold)
                            .padding()
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.white)
                            )
                    }
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Sign In")
                            .foregroundStyle(.white)
                            .fontWeight(.bold)
                            .padding()
                            .padding(.horizontal, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(.black)
                            )
                    }
                }
            }
            .foregroundStyle(.white)
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    SplashScreen()
}
