//
//  TLCTests.swift
//  TLCTests
//
//  Created by Justin Lycklama on 2020-09-09.
//  Copyright © 2020 Justin Lycklama. All rights reserved.
//

import XCTest

class TLCTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
////
////        let siri = XCUIDevice.shared.siriService
////        siri.activate(voiceRecognitionText: "How are you?")
////        let predicate = NSPredicate {(_, _) -> Bool in
////            sleep(5)
////            return true
////        }
////
////        let siriResponse = expectation(for: predicate, evaluatedWith: siri, handler: nil)
////        self.wait(for: [siriResponse], timeout: 10)
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
