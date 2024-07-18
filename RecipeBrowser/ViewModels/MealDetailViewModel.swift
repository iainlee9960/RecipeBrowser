//
//  MealDetailViewModel.swift
//  RecipeBrowser
//
//  Created by Iain Lee on 7/18/24.
//

import Foundation


class MealDetailViewModel: ObservableObject {
    @Published var mealDetail: MealDetail?
    @Published var isLoading = false
    @Published var error: Error?

    func fetchMealDetail(mealID: String) {
        isLoading = true
        error = nil
        Task {
            do {
                let mealDetail = try await NetworkManager.shared.fetchMealDetails(mealID: mealID)
                DispatchQueue.main.async {
                    self.mealDetail = mealDetail
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}

