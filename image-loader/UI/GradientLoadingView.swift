//
//  GradientLoadingView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import SwiftUI

struct GradientLoadingView: View {
    
    @State private var animateGradient = false
    
    private var gradientColors: [Color] {
        [.gray.opacity(0.6), .gray.opacity(0.3), .gray.opacity(0.1)]
    }
    
    private var reversedGradientColors: [Color] {
        [.gray.opacity(0.1), .gray.opacity(0.3), .gray.opacity(0.6)]
    }
    
    var body: some View {
        GeometryReader { geometry in
            LinearGradient(
                gradient: Gradient(colors: animateGradient ? gradientColors : reversedGradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .onAppear {
                animateGradient = false
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    animateGradient.toggle()
                }
            }
        }
    }
}

#Preview {
    GeometryReader { geometry in
        VStack {
            GradientLoadingView()
            GradientLoadingView()
        }
        .frame(maxWidth: .infinity)
    }
}
