//
//  ResumeControllerTests.swift
//  ArcwindResumeTests
//
//  Created by Marcel Dierkes on 14.02.23.
//

import XCTest
import ArcwindResume

/// - Warning: Tests `ResumeController` using actual network requests!
final class ResumeControllerTests: XCTestCase {
    var controller: ResumeController!
    var notificationCenter: NotificationCenter!
    var urlSession: URLSession!
    
    override func setUp() async throws {
        let notificationCenter = NotificationCenter.default
        let urlSession = URLSession.shared
        self.controller = ResumeController(
            urlSession: urlSession,
            notificationCenter: notificationCenter,
            performInitialRequest: false
        )
        self.urlSession = urlSession
        self.notificationCenter = notificationCenter
    }
    
    override func tearDown() async throws {
        self.controller = nil
        self.urlSession = nil
        self.notificationCenter = nil
    }
    
    func testGetResume() {
        let expectation = self.expectation(description: #function)
        
        self.controller.getResume { result in
            switch result {
            case .success(let resume):
                XCTAssertEqual(self.controller.resume, resume)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 5.0)
    }
}
