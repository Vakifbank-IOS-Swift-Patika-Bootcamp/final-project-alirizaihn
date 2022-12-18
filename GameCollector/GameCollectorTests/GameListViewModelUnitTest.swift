//
//  GameListViewModelUnitTest.swift
//  GameCollectorTests
//
//  Created by Ali Rıza İLHAN on 18.12.2022.
//

import XCTest

final class GameListViewModelUnitTest: XCTestCase {

    var viewModel: GameListViewModel!
    var fetchExpectation: XCTestExpectation!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = GameListViewModel()
        fetchExpectation = expectation(description: "fetchGames")
    }


    func testGetGamesCount() throws {
//       Given
        viewModel.delegate = self
        XCTAssertEqual(viewModel.getGamesCount(), 0)
        
//        When
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
//        Then
        XCTAssertEqual(viewModel.getGamesCount(), 15)
    }
    
    func testGetGameWithIndex() throws {
        viewModel.delegate = self
        XCTAssertNil(viewModel.getGame(at: 0))
        
        viewModel.fetchGames()
        waitForExpectations(timeout: 10)
        
        let firstItem = viewModel.getGame(at: 0)
        XCTAssertEqual(firstItem?.id, 3498)
    }
    
        
}
extension GameListViewModelUnitTest: GameListViewModelDelegate {
    func startFetching() {
        print("")
    }
    
    func endingFetching() {
        print("")
    }
    
    func gameLoaded() {
        fetchExpectation.fulfill()
    }
    
    func genreLoaded() {
        print("")
    }
    
    func onError(message: String) {
        print("")
    }
    
    
}
