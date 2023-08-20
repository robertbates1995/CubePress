//
//  CubePressTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 12/21/22.
//

import XCTest
import KociembaSolver
@testable import CubePress

@MainActor
final class CubePressTests: XCTestCase {
    let sut = AppManager()
    let incoming = "{\"center\": 1550000, \"right\": 47, \"bot\": 1600000, \"left\": 3000000, \"top\": 750000, \"mid\": 1230000}"
    let expected = [Move.center: "1550000", .right: "47", .bot: "1600000", .left: "3000000", .top: "750000", .mid: "1230000"]
    
    func testBinding() throws {
        let binding = sut.settingsModel.binding(for: .top)
        XCTAssertEqual(sut.settingsModel.settings, [:])
        XCTAssertEqual(binding.wrappedValue, "")
        binding.wrappedValue = "42"
        XCTAssertEqual(sut.settingsModel.settings, [.top: "42"])
        XCTAssertEqual(binding.wrappedValue, "42")
        let centerBinding = sut.settingsModel.binding(for: .center)
        centerBinding.wrappedValue = "47"
        XCTAssertEqual(sut.settingsModel.settings, [.center: "47", .top: "42"])
        XCTAssertEqual(centerBinding.wrappedValue, "47")
    }
    
    func testConversion() throws {
        let data = try XCTUnwrap(incoming.data(using:.utf8))
        sut.settingsModel.processData(data)
        XCTAssertNil(sut.settingsModel.errorMessage)
        XCTAssertEqual(sut.settingsModel.settings, expected)
    }
    
    func testKociembaSolver(map: String, expected: String) {
        let tmp = FileManager.default.temporaryDirectory.path
        let solutionPtr = ApplyKociembaAlgorithm(strdup(map), 25000, 500, 0, tmp)
        if let solutionPtr {
            let solution = String(cString: solutionPtr)
            XCTAssertEqual(solution, expected)
        } else {
            print("no solution to map: \(map)")
        }
    }

    func testSolver() {
        testKociembaSolver(map: "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB", expected: "R L U2 R L' B2 U2 R2 F2 L2 D2 L2 F2 ")
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        
        //checking each individual conversion
        XCTAssertEqual(sut.solver.convert(instructions: "U "), ["TMTMBLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "U' "), ["TMTMBRMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "U2 "), ["TMTMLBRMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "U2' "), ["TMTMLBRMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "D "), ["BLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "R "), ["RTMCBLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "L "), ["LTMCBLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "F "), ["TMBLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
        XCTAssertEqual(sut.solver.convert(instructions: "B "), ["TMTMTMBLMC"])
        sut.solver.referenceFrame = ["U" : "U",
                                     "L" : "L",
                                     "F" : "F",
                                     "R" : "R",
                                     "B" : "B",
                                     "D" : "D",]
    }
}
