import Testing
import Foundation
@testable import BreakApp

struct QuestionnaireViewModelTests {

    private func makeSUT() -> (QuestionnaireViewModel, MockDataRepository) {
        let repo = MockDataRepository()
        let vm = QuestionnaireViewModel(dataRepository: repo, userId: "test-user-123")
        return (vm, repo)
    }

    // MARK: - Task Selection

    @Test func toggleTask_addsToSelection() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        #expect(vm.selectedTasks.contains(.sweeping))
    }

    @Test func toggleTask_removesIfAlreadySelected() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.toggleTask(.sweeping)
        #expect(!vm.selectedTasks.contains(.sweeping))
    }

    @Test func toggleNone_clearsOtherTasks() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.toggleTask(.mopping)
        vm.toggleTask(.none)
        #expect(vm.selectedTasks == [.none])
    }

    @Test func toggleTask_removesNone() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.none)
        vm.toggleTask(.laundry)
        #expect(!vm.selectedTasks.contains(.none))
        #expect(vm.selectedTasks.contains(.laundry))
    }

    // MARK: - Validation

    @Test func continueDisabled_whenNoTasksSelected() {
        let (vm, _) = makeSUT()
        vm.setHasSmartphone(true)
        vm.setHasUsedGoogleMaps(true)
        #expect(!vm.isContinueEnabled)
    }

    @Test func continueDisabled_whenSmartphoneNotAnswered() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasUsedGoogleMaps(true)
        #expect(!vm.isContinueEnabled)
    }

    @Test func continueDisabled_whenGoogleMapsNotAnswered() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasSmartphone(true)
        #expect(!vm.isContinueEnabled)
    }

    @Test func continueEnabled_whenAllAnswered() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasSmartphone(true)
        vm.setHasUsedGoogleMaps(true)
        #expect(vm.isContinueEnabled)
    }

    @Test func continueDisabled_whenNoSmartphoneAndCanGetPhoneNotAnswered() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasSmartphone(false)
        vm.setHasUsedGoogleMaps(true)
        #expect(!vm.isContinueEnabled)
    }

    @Test func continueEnabled_whenNoSmartphoneAndCanGetPhoneAnswered() {
        let (vm, _) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasSmartphone(false)
        vm.setCanGetPhone(true)
        vm.setHasUsedGoogleMaps(true)
        #expect(vm.isContinueEnabled)
    }

    // MARK: - Dynamic Questions

    @Test func shouldShowCanGetPhone_whenNoSmartphone() {
        let (vm, _) = makeSUT()
        vm.setHasSmartphone(false)
        #expect(vm.shouldShowCanGetPhone)
    }

    @Test func shouldNotShowCanGetPhone_whenHasSmartphone() {
        let (vm, _) = makeSUT()
        vm.setHasSmartphone(true)
        #expect(!vm.shouldShowCanGetPhone)
    }

    @Test func canGetPhoneResets_whenSmartphoneChangesToYes() {
        let (vm, _) = makeSUT()
        vm.setHasSmartphone(false)
        vm.setCanGetPhone(true)
        vm.setHasSmartphone(true)
        #expect(vm.canGetPhone == nil)
    }

    // MARK: - Submit

    @Test func submit_sendsCorrectDataToRepository() async throws {
        let (vm, repo) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.toggleTask(.mopping)
        vm.setHasSmartphone(true)
        vm.setHasUsedGoogleMaps(false)

        var didCallSuccess = false
        vm.onSubmitSuccess = { didCallSuccess = true }
        vm.submit()

        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(repo.submitCalledWith != nil)
        #expect(repo.submitCalledWith?.userId == "test-user-123")
        #expect(repo.submitCalledWith?.hasSmartphone == true)
        #expect(repo.submitCalledWith?.hasUsedGoogleMaps == false)
        #expect(didCallSuccess)
    }

    @Test func submit_callsOnError_whenRepositoryFails() async throws {
        let (vm, repo) = makeSUT()
        vm.toggleTask(.sweeping)
        vm.setHasSmartphone(true)
        vm.setHasUsedGoogleMaps(true)

        repo.submitQuestionnaireResult = .failure(NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network error"]))

        var errorMessage: String?
        vm.onError = { errorMessage = $0 }
        vm.submit()

        try await Task.sleep(nanoseconds: 500_000_000)

        #expect(errorMessage == "Network error")
        #expect(!vm.isSubmitting)
    }
}
