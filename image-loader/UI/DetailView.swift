//
//  DetailView.swift
//  image-loader
//
//  Created by Luis Francisco Piura Mejia on 7/3/25.
//

import Kingfisher
import SwiftUI

struct DetailView: View {
    
    @StateObject var viewModel: DetailViewModel
    @State var loading: Bool = true
    
    var body: some View {
        GeometryReader { geometry in
            KFImage(viewModel.url)
                .onSuccess { _ in
                    loading = false
                }
                .resizable()
                .scaledToFit()
                .frame(width: geometry.size.width)
                .onAppear {
                    viewModel.measureImageHeight(forScreenWidth: geometry.size.width)
                }
        }
        .background(loading ? GradientLoadingView() : nil)
        .frame(height: viewModel.cellHeight)
    }
}
