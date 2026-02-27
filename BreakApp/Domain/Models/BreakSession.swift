import Foundation

struct BreakSession: Codable {
    let startTime: Date
    let durationSeconds: Int
    let userId: String
    var endedEarly: Bool
    var actualEndTime: Date?

    var endTime: Date {
        startTime.addingTimeInterval(TimeInterval(durationSeconds))
    }

    var remainingSeconds: Int {
        let remaining = endTime.timeIntervalSince(Date())
        return max(0, Int(remaining))
    }

    var isExpired: Bool {
        Date() >= endTime || endedEarly
    }
}
