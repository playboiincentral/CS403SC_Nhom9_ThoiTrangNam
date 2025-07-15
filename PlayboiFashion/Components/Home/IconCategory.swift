//
//  IconCategory.swift
//  PlayboiFashion
//
//  Created by Playboi In Central on 3/5/25.
//

import SwiftUI

struct IconCategory: View {
    let displayImg: String
    let displayName: String
    var body: some View {
        VStack {
            Image(systemName: displayImg)
                .font(.title)
                .foregroundStyle(.black)
            Text(displayName)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
        }
        .background(
            Circle()
                .foregroundStyle(.white)
        )
    }
}

#Preview {
    ContentView()
}
