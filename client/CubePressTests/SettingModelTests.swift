//
//  SettingModelTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 1/4/23.
//

import XCTest
@testable import CubePress

final class SettingModelTests: XCTestCase {

    func testButtonPressed() throws {
        var pressed = false
        let sut = SettingModel(sliderValue: 10, title: "Test Title", buttonLabel: "Test Button", action: {pressed = true})
        XCTAssertFalse(pressed)
        sut.buttonPressed()
        XCTAssertTrue(pressed)

        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

}
