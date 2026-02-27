//
//  BreakViewModel.swift
//  BreakApp
//
//  Created by Nishant Gulani on 26/02/26.
//

import Foundation

final class BreakViewModel {

    enum State: Equatable {
        case loading
        case active(remaining: Int, total: Int)
        case ended
        case noBreak
        case error(String)

        static func == (lhs: State, rhs: State) -> Bool {
            switch (lhs, rhs) {
            case (.loading, .loading), (.ended, .ended), (.noBreak, .noBreak):
                return true
            case let (.active(r1, t1), .active(r2, t2)):
                return r1 == r2 && t1 == t2
            case let (.error(m1), .error(m2)):
                return m1 == m2
            default:
                return false
            }
        }
    }

    private let dataRepository: DataRepositoryProtocol
    private let userId: String
    private var timer: Timer?
    private var breakSession: BreakSession?

    var state: State = .loading {
        didSet { onStateChanged?() }
    }

    var onStateChanged: (() -> Void)?
    var onBreakEnded: (() -> Void)?
    var onLogout: (() -> Void)?

    init(dataRepository: DataRepositoryProtocol, userId: String) {
        self.dataRepository = dataRepository
        self.userId = userId
    }

    deinit {
        timer?.invalidate()
    }

    // MARK: - Public

    func loadBreak() {
        state = .loading
        Task {
            do {
                let session = try await dataRepository.fetchBreakSession(for: userId)
                await MainActor.run {
                    guard let session else {
                        state = .noBreak
                        return
                    }
                    breakSession = session
                    if session.isExpired {
                        state = .ended
                    } else {
                        startTimer(session: session)
                    }
                }
            } catch {
                await MainActor.run {
                    state = .error(error.localizedDescription)
                }
            }
        }
    }

    func endBreakEarly() {
        timer?.invalidate()
        Task {
            do {
                try await dataRepository.endBreakEarly(for: userId)
                await MainActor.run {
                    state = .ended
                }
            } catch {
                await MainActor.run {
                    state = .error(error.localizedDescription)
                }
            }
        }
    }

    // MARK: - Formatted Time

    var formattedTime: String {
        guard case let .active(remaining, _) = state else { return "00:00" }
        let minutes = remaining / 60
        let seconds = remaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var progress: CGFloat {
        guard case let .active(remaining, total) = state, total > 0 else { return 0 }
        return CGFloat(total - remaining) / CGFloat(total)
    }

    var formattedEndTime: String {
        guard let session = breakSession else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return "Break ends at \(formatter.string(from: session.endTime))"
    }

    // MARK: - Private

    private func startTimer(session: BreakSession) {
        let total = session.durationSeconds
        state = .active(remaining: session.remainingSeconds, total: total)

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self, let session = self.breakSession else { return }
            let remaining = session.remainingSeconds
            if remaining <= 0 {
                self.timer?.invalidate()
                self.state = .ended
            } else {
                self.state = .active(remaining: remaining, total: total)
            }
        }
    }
}
