//
//  MyGitHubTests.swift
//  MyGitHubTests
//
//  Created by Frank Fan on 2026/3/18.
//

import XCTest
@testable import MyGitHub

class SecureStorageTests: XCTestCase {

    let storage = AuthService.shared
    
    override func setUp() {
        super.setUp()
        storage.logout()
    }
    
    func testSaveAndGetToken() {
        storage.login(username: "test", password: "test_token_123") { res in
            XCTAssertEqual(self.storage.getToken(), "test_token_123")
        }
    }

}
