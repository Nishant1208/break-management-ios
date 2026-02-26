//
//  QuestionnaireViewModel.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

// MARK: - Models

struct SkillOption {
    let title: String
    var isSelected: Bool
}

// MARK: - ViewModel

final class QuestionnaireViewModel {

    // MARK: - State

    private(set) var skillOptions: [SkillOption] = [
        SkillOption(title: "Cutting vegetables", isSelected: false),
        SkillOption(title: "Sweeping", isSelected: false),
        SkillOption(title: "Mopping", isSelected: false),
        SkillOption(title: "Cleaning bathrooms", isSelected: false),
        SkillOption(title: "Laundry", isSelected: false),
        SkillOption(title: "Washing dishes", isSelected: false),
        SkillOption(title: "None of the above", isSelected: false)
    ]

    private(set) var hasSmartphone: Bool?
    private(set) var willGetPhone: Bool?
    private(set) var hasUsedGoogleMaps: Bool?
    private(set) var dateOfBirth: (day: String, month: String, year: String) = ("", "", "")

    // MARK: - Derived State

    var shouldShowWillGetPhoneQuestion: Bool {
        hasSmartphone == false
    }

    var isFormValid: Bool {
        let hasSkillSelection = skillOptions.contains(where: \.isSelected)
        let hasSmartphoneAnswer = hasSmartphone != nil
        let hasPhoneAnswer = !shouldShowWillGetPhoneQuestion || willGetPhone != nil
        let hasGoogleMapsAnswer = hasUsedGoogleMaps != nil
        let hasValidDate = !dateOfBirth.day.isEmpty
            && !dateOfBirth.month.isEmpty
            && !dateOfBirth.year.isEmpty

        return hasSkillSelection
            && hasSmartphoneAnswer
            && hasPhoneAnswer
            && hasGoogleMapsAnswer
            && hasValidDate
    }

    // MARK: - Callbacks

    var onFormStateChanged: (() -> Void)?
    var onSubmitSuccess: (() -> Void)?
    var onError: ((String) -> Void)?
    var onBack: (() -> Void)?

    // MARK: - Skill Actions

    func toggleSkill(at index: Int) {
        let isNoneOption = index == skillOptions.count - 1

        if isNoneOption {
            let wasSelected = skillOptions[index].isSelected
            for i in skillOptions.indices {
                skillOptions[i].isSelected = false
            }
            skillOptions[index].isSelected = !wasSelected
        } else {
            skillOptions[index].isSelected.toggle()
            skillOptions[skillOptions.count - 1].isSelected = false
        }

        onFormStateChanged?()
    }

    // MARK: - Radio Actions

    func setHasSmartphone(_ value: Bool) {
        hasSmartphone = value
        if value {
            willGetPhone = nil
        }
        onFormStateChanged?()
    }

    func setWillGetPhone(_ value: Bool) {
        willGetPhone = value
        onFormStateChanged?()
    }

    func setHasUsedGoogleMaps(_ value: Bool) {
        hasUsedGoogleMaps = value
        onFormStateChanged?()
    }

    // MARK: - Date Actions

    func setDateOfBirth(day: String, month: String, year: String) {
        dateOfBirth = (day, month, year)
        onFormStateChanged?()
    }

    // MARK: - Submit

    func submit() {
        guard isFormValid else {
            onError?("Please complete all questions.")
            return
        }
        onSubmitSuccess?()
    }
}
