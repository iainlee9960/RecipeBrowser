//
//  BottomBar.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/20/24.
//

import Foundation
import SwiftUI

struct BottomBar: View {
    @Binding var currentView: ViewType
    @Environment(\.colorScheme) var colorScheme

    let mainColor = Color.mainColor

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color(red: 240/255, green: 240/255, blue: 240/255).opacity(0.01))
                .frame(height: 0.01)

            HStack(spacing: 0) {
                BarButton(
                    assetName: getHomeIconName(),
                    mainColor: mainColor,
                    isActive: .constant(currentView == .home)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    handleButtonTap(viewType: .home)
                }

                BarButton(
                    imageName: "person.fill",
                    mainColor: mainColor,
                    isActive: .constant(currentView == .profile)
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    handleButtonTap(viewType: .profile)
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .padding(.bottom, 30)
        .edgesIgnoringSafeArea(.horizontal)
    }
    
    func getHomeIconName() -> String {
        if colorScheme == .dark {
            return currentView == .home ? "home_white" : "home_gray"
        } else {
            return currentView == .home ? "home" : "home_lightgray"
        }
    }
    
    private func handleButtonTap(viewType: ViewType) {
        currentView = viewType
    }
}

struct BarButton: View {
    let assetName: String?
    let imageName: String?
    let mainColor: Color
    @Binding var isActive: Bool
    @Environment(\.colorScheme) var colorScheme

    init(assetName: String? = nil, imageName: String? = nil, mainColor: Color, isActive: Binding<Bool>) {
        self.assetName = assetName
        self.imageName = imageName
        self.mainColor = mainColor
        self._isActive = isActive
    }

    var body: some View {
        VStack {
            if let assetName = assetName {
                Image(assetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 26)
                    .foregroundColor(isActive ? (colorScheme == .dark ? Color.white : Color.black) : (colorScheme == .dark ? Color.gray : Color(red: 200/255, green: 200/255, blue: 200/255)))
            } else if let imageName = imageName {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(isActive ? (colorScheme == .dark ? Color.white : Color.black) : (colorScheme == .dark ? Color.gray : Color(red: 200/255, green: 200/255, blue: 200/255)))
                    .frame(width: 130, height: 23)
            }
        }
        .padding(.vertical, 11.5)
        .frame(maxWidth: .infinity)
    }
}
