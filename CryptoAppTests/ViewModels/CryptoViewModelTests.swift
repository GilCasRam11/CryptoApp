import XCTest
@testable import CryptoApp

class CryptoViewModelTests: XCTestCase {
    var viewModel: CryptoViewModel!
    var repositoryMock: CryptoRepositoryMock!

    override func setUp() async throws {
        try await super.setUp()
        repositoryMock = CryptoRepositoryMock()
        await MainActor.run { // ✅ Asegurar que ViewModel se inicializa en el hilo principal
                    viewModel = CryptoViewModel(repository: repositoryMock)
                }
    }

    func testFetchCryptosSuccess() async {
        repositoryMock.shouldFail = false
        await viewModel.fetchCryptos()
        
        await MainActor.run {
            XCTAssertFalse(viewModel.cryptos.isEmpty, "Cryptos should not be empty")
            XCTAssertNil(viewModel.errorMessage, "Error message should be nil on success")
        }
    }

    func testFetchCryptosFailure() async {
        repositoryMock.shouldFail = true
        await viewModel.fetchCryptos()
        
        await MainActor.run {
            XCTAssertTrue(viewModel.cryptos.isEmpty, "Cryptos should be empty on failure")
            XCTAssertNotNil(viewModel.errorMessage, "Error message should not be nil on failure")
        }
    }
}

