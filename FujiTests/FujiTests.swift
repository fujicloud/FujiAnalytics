//
//  FujiTests.swift
//  FujiTests
//
//  Created by Jack Cook on 8/13/17.
//  Copyright © 2017 Fuji. All rights reserved.
//

import XCTest
import Fuji

class FujiTests: XCTestCase, FujiDelegate {
    
    private var eventExpectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        do {
            try Fuji.shared.start()
            Fuji.shared.delegate = self
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
        // This is kind of a hack, simulates exiting the app to test session queuing
        NotificationCenter.default.post(name: Notification.Name.UIApplicationDidEnterBackground, object: nil)
        
        super.tearDown()
    }
    
    func testEvent() {
        eventExpectation = expectation(description: "content view event")
        
        let event = FujiEvent(type: .contentView(page: "Home"))
        Fuji.shared.send(event: event)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    // MARK: - FujiDelegate Methods
    
    func sentEvent(event: FujiEvent, successfully success: Bool) {
        guard success == true else {
            XCTFail()
            return
        }
        
        eventExpectation?.fulfill()
    }
}
