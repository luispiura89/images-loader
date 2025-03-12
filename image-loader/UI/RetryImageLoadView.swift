//
//  RetryImageLoadView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 12/3/25.
//

import SwiftUI

struct RetryImageLoadView: View {
    
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                GradientLoadingView()
                Image(systemName: "arrow.clockwise.circle")
                    .font(.system(size: 32))
                    .foregroundStyle(.white)
            }
        }
    }
}
