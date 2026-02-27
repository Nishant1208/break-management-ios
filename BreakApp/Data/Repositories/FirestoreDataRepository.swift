import Foundation
import FirebaseFirestore

final class FirestoreDataRepository: DataRepositoryProtocol {

    private let db = Firestore.firestore()

    func submitQuestionnaire(_ response: QuestionnaireResponse) async throws {
        let data: [String: Any] = [
            "userId": response.userId,
            "selectedTasks": response.selectedTasks,
            "hasSmartphone": response.hasSmartphone,
            "hasUsedGoogleMaps": response.hasUsedGoogleMaps,
            "canGetPhone": response.canGetPhone as Any,
            "submittedAt": Timestamp(date: response.submittedAt)
        ]
        try await db.collection("questionnaire_responses")
            .document(response.userId)
            .setData(data)
    }

    func hasSubmittedQuestionnaire(userId: String) async throws -> Bool {
        let snapshot = try await db.collection("questionnaire_responses")
            .document(userId)
            .getDocument()
        return snapshot.exists
    }

    func fetchBreakSession(for userId: String) async throws -> BreakSession? {
        let snapshot = try await db.collection("breaks")
            .document(userId)
            .getDocument()

        guard let data = snapshot.data() else { return nil }

        let startTimestamp = data["start_time"] as? Timestamp ?? Timestamp()
        let duration = data["duration"] as? Int ?? 0
        let endedEarly = data["ended_early"] as? Bool ?? false
        let actualEndTimestamp = data["actual_end_time"] as? Timestamp

        return BreakSession(
            startTime: startTimestamp.dateValue(),
            durationSeconds: duration,
            userId: userId,
            endedEarly: endedEarly,
            actualEndTime: actualEndTimestamp?.dateValue()
        )
    }

    func endBreakEarly(for userId: String) async throws {
        try await db.collection("breaks")
            .document(userId)
            .updateData([
                "ended_early": true,
                "actual_end_time": Timestamp(date: Date())
            ])
    }
}
