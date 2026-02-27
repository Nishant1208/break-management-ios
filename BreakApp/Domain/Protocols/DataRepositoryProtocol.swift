//
//  DataRepositoryProtocol.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

protocol DataRepositoryProtocol {
    func submitQuestionnaire(_ response: QuestionnaireResponse) async throws
    func hasSubmittedQuestionnaire(userId: String) async throws -> Bool
    func fetchBreakSession(for userId: String) async throws -> BreakSession?
    func endBreakEarly(for userId: String) async throws
}
