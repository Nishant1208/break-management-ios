import Foundation

struct QuestionnaireResponse: Codable {
    let userId: String
    let selectedTasks: [String]
    let hasSmartphone: Bool
    let hasUsedGoogleMaps: Bool
    let canGetPhone: Bool?
    let submittedAt: Date
}
