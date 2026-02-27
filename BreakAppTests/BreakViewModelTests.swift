import Testing
import Foundation
@testable import BreakApp

struct BreakViewModelTests {

    private func makeSUT() -> (BreakViewModel, MockDataRepository) {
        let repo = MockDataRepository()
        let vm = BreakViewModel(dataRepository: repo, userId: "test-user-123")
        return (vm, repo)
    }

    // MARK: - Load Break

    @Test func loadBreak_setsNoBreak_whenNoSessionExists() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = nil

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(vm.state == .noBreak)
    }

    @Test func loadBreak_setsEnded_whenSessionExpired() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = BreakSession(
            startTime: Date().addingTimeInterval(-600),
            durationSeconds: 300,
            userId: "test-user-123",
            endedEarly: false,
            actualEndTime: nil
        )

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(vm.state == .ended)
    }

    @Test func loadBreak_setsActive_whenSessionNotExpired() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "test-user-123",
            endedEarly: false,
            actualEndTime: nil
        )

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        if case .active(let remaining, let total) = vm.state {
            #expect(total == 300)
            #expect(remaining > 0)
        } else {
            Issue.record("Expected active state")
        }
    }

    @Test func loadBreak_setsEnded_whenEndedEarly() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "test-user-123",
            endedEarly: true,
            actualEndTime: Date()
        )

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(vm.state == .ended)
    }

    // MARK: - Formatted Time

    @Test func formattedTime_returnsCorrectFormat() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "test-user-123",
            endedEarly: false,
            actualEndTime: nil
        )

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        let time = vm.formattedTime
        let parts = time.split(separator: ":")
        #expect(parts.count == 2)
    }

    // MARK: - Progress

    @Test func progress_isZero_whenNotActive() {
        let (vm, _) = makeSUT()
        #expect(vm.progress == 0)
    }

    // MARK: - End Early

    @Test func endBreakEarly_callsRepository() async throws {
        let (vm, repo) = makeSUT()
        repo.breakSession = BreakSession(
            startTime: Date(),
            durationSeconds: 300,
            userId: "test-user-123",
            endedEarly: false,
            actualEndTime: nil
        )

        vm.loadBreak()
        try await Task.sleep(nanoseconds: 500_000_000)

        vm.endBreakEarly()
        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(repo.endBreakEarlyCalledForUser == "test-user-123")
        #expect(vm.state == .ended)
    }
}
