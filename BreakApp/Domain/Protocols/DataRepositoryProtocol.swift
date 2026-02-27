import Foundation

protocol DataRepositoryProtocol {
    func submitQuestionnaire(_ response: QuestionnaireResponse) async throws
    func hasSubmittedQuestionnaire(userId: String) async throws -> Bool
    func fetchBreakSession(for userId: String) async throws -> BreakSession?
    func endBreakEarly(for userId: String) async throws
}
