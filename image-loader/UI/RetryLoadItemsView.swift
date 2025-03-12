//
//  RetryLoadItemsView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 12/3/25.
//

import SwiftUI

struct RetryLoadItemsView: View {

    let onTap: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: onTap) {
                Text("Something went wrong. Tap to retry.")
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.red.opacity(0.4))
            }
        }
    }
}
