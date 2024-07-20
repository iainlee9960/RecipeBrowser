//
//  ContentView.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.currentView == .home {
                HomeView(viewModel: viewModel)
            } else if viewModel.currentView == .profile {
                ProfileView(viewModel: viewModel)
            }
            
            if !viewModel.categories.isEmpty {
                BottomBar(currentView: $viewModel.currentView)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
