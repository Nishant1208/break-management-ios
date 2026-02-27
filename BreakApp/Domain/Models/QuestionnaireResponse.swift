//
//  QuestionnaireResponse.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

struct QuestionnaireResponse: Codable {
    let userId: String
    let selectedTasks: [String]
    let hasSmartphone: Bool
    let hasUsedGoogleMaps: Bool
    let canGetPhone: Bool?
    let submittedAt: Date
}
