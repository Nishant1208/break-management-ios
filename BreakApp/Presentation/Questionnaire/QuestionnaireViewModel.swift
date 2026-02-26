//
//  QuestionnaireViewModel.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

final class QuestionnaireViewModel {

    enum Task: String, CaseIterable {
        case cuttingVegetables = "Cutting vegetables"
        case sweeping = "Sweeping"
        case mopping = "Mopping"
        case cleaningBathrooms = "Cleaning bathrooms"
        case laundry = "Laundry"
        case washingDishes = "Washing dishes"
        case none = "None of the above"
    }

    var selectedTasks: Set<Task> = []
    var hasSmartphone: Bool?
    var hasUsedGoogleMaps: Bool?
    var canGetPhone: Bool?

    var onStateChanged: (() -> Void)?

    var onBack: (() -> Void)?
    var onSubmitSuccess: (() -> Void)?


    // MARK: - Task Handling

    func toggleTask(_ task: Task) {
        if task == .none {
            selectedTasks = [.none]
        } else {
            selectedTasks.remove(.none)
            if selectedTasks.contains(task) {
                selectedTasks.remove(task)
            } else {
                selectedTasks.insert(task)
            }
        }
        onStateChanged?()
    }

    // MARK: - Smartphone Handling

    func setHasSmartphone(_ value: Bool) {
        hasSmartphone = value
        if value == true {
            canGetPhone = nil
        }
        onStateChanged?()
    }

    func setHasUsedGoogleMaps(_ value: Bool) {
        hasUsedGoogleMaps = value
        onStateChanged?()
    }

    func setCanGetPhone(_ value: Bool) {
        canGetPhone = value
        onStateChanged?()
    }

    // MARK: - Validation

    var shouldShowCanGetPhone: Bool {
        return hasSmartphone == false
    }

    var isContinueEnabled: Bool {
        guard !selectedTasks.isEmpty,
              let hasSmartphone = hasSmartphone,
              hasUsedGoogleMaps != nil else { return false }

        if hasSmartphone == false {
            return canGetPhone != nil
        }
        return true
    }
}
