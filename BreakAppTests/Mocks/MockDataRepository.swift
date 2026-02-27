//
//  MockDataRepository.swift
//  BreakAppTests
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation
@testable import BreakApp

final class MockDataRepository: DataRepositoryProtocol {

    var submitQuestionnaireResult: Result<Void, Error> = .success(())
    var hasSubmittedResult: Bool = false
    var breakSession: BreakSession?
    var endBreakEarlyResult: Result<Void, Error> = .success(())

    var submitCalledWith: QuestionnaireResponse?
    var endBreakEarlyCalledForUser: String?

    func submitQuestionnaire(_ response: QuestionnaireResponse) async throws {
        submitCalledWith = response
        try submitQuestionnaireResult.get()
    }

    func hasSubmittedQuestionnaire(userId: String) async throws -> Bool {
        return hasSubmittedResult
    }

    func fetchBreakSession(for userId: String) async throws -> BreakSession? {
        return breakSession
    }

    func endBreakEarly(for userId: String) async throws {
        endBreakEarlyCalledForUser = userId
        try endBreakEarlyResult.get()
    }
}
