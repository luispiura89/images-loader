//
//  ImageItemView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 27/2/25.
//

import Kingfisher
import SwiftUI

struct ImageItemView: View {

    @StateObject var viewModel: ImageItemViewModel
    
    private enum Constants {
        static let cornerRadius: CGFloat = 20
        static let authorPad: CGFloat = 10
        static let horizontalPad: CGFloat = 10
        
        static let gradientOpacity: Double = 0.2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomTrailing) {
                KFImage(viewModel.url(maxWidth: maxCellWidth(in: geometry)))
                    .placeholder {
                        GradientLoadingView()
                            .frame(width: maxCellWidth(in: geometry), height: geometry.size.height)
                    }
                    .resizable()
                    .scaledToFit()
                    .background(
                        LinearGradient(
                            gradient: Gradient(
                                colors: [.clear, .black.opacity(Constants.gradientOpacity)]
                            ),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .onTapGesture(perform: viewModel.onTapView)
            }
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            .padding(.horizontal, Constants.horizontalPad)
            .onAppear {
                viewModel.measureCellHeight(withMacWidth: maxCellWidth(in: geometry))
            }
        }
        .frame(height: viewModel.cellHeight)
    }
    
    private func maxCellWidth(in geometry: GeometryProxy) -> CGFloat {
        geometry.size.width - Constants.horizontalPad * 2
    }
}

#Preview {
    GeometryReader { geometry in
        ScrollView {
            VStack(spacing: 20) {
                ImageItemView(
                    viewModel: .init(
                        model: .init(id: "1", author: "First author", width: 1000, height: 200, url: URL(string: "https://any-url.com/image.jpg")!)
                    ) {}
                )
                
                ImageItemView(
                    viewModel: .init(
                        model: .init(id: "2", author: "Second author", width: 3000, height: 5000, url: URL(string: "https://any-url.com/image.jpg")!)
                    ) {}
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
}
