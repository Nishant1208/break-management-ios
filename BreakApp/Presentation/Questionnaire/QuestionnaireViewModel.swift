//
//  QuestionnaireViewModel.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

final class QuestionnaireViewModel {

    enum SkillTask: String, CaseIterable {
        case cuttingVegetables = "Cutting vegetables"
        case sweeping = "Sweeping"
        case mopping = "Mopping"
        case cleaningBathrooms = "Cleaning bathrooms"
        case laundry = "Laundry"
        case washingDishes = "Washing dishes"
        case none = "None of the above"
    }

    private let dataRepository: DataRepositoryProtocol
    private let userId: String

    var selectedTasks: Set<SkillTask> = []
    var hasSmartphone: Bool?
    var hasUsedGoogleMaps: Bool?
    var canGetPhone: Bool?
    var isSubmitting = false

    var onStateChanged: (() -> Void)?
    var onError: ((String) -> Void)?
    var onBack: (() -> Void)?
    var onSubmitSuccess: (() -> Void)?

    init(dataRepository: DataRepositoryProtocol, userId: String) {
        self.dataRepository = dataRepository
        self.userId = userId
    }


    // MARK: - Task Handling

    func toggleTask(_ task: SkillTask) {
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
        guard !selectedTasks.isEmpty, !isSubmitting,
              let hasSmartphone = hasSmartphone,
              hasUsedGoogleMaps != nil else { return false }

        if hasSmartphone == false {
            return canGetPhone != nil
        }
        return true
    }

    // MARK: - Submit

    func submit() {
        guard isContinueEnabled else { return }
        isSubmitting = true
        onStateChanged?()

        let response = QuestionnaireResponse(
            userId: userId,
            selectedTasks: selectedTasks.map(\.rawValue),
            hasSmartphone: hasSmartphone ?? false,
            hasUsedGoogleMaps: hasUsedGoogleMaps ?? false,
            canGetPhone: canGetPhone,
            submittedAt: Date()
        )

        Task {
            do {
                try await dataRepository.submitQuestionnaire(response)
                await MainActor.run {
                    isSubmitting = false
                    onSubmitSuccess?()
                }
            } catch {
                await MainActor.run {
                    isSubmitting = false
                    onStateChanged?()
                    onError?(error.localizedDescription)
                }
            }
        }
    }
}
