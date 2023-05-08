//
//  SolverTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 3/17/23.
//

import XCTest
@testable import CubePress

@MainActor
final class SolverTests: XCTestCase {
    let sut = AppManager()
    
    func testU() {
        //checking each individual conversion
        XCTAssertEqual(sut.solver.convert(instructions: "U "), "TMTMBRMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "R", "U": "D", "L": "B", "R": "F", "D": "U", "B": "L"])
        XCTAssertEqual(sut.solver.convert(instructions: "U "), "BRMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "F", "U": "D", "L": "R", "R": "L", "D": "U", "B": "B"])
    }
    
    func testUPrime() {
        //checking each individual conversion
        XCTAssertEqual(sut.solver.convert(instructions: "U' "), "TMTMBLMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "L", "U": "D", "L": "F", "R": "B", "D": "U", "B": "R"])
        XCTAssertEqual(sut.solver.convert(instructions: "U' "), "BLMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "F", "U": "D", "L": "R", "R": "L", "D": "U", "B": "B"])
    }
    
    func testU2() {
        //checking each individual conversion
        XCTAssertEqual(sut.solver.convert(instructions: "U2 "), "TMTMLBRMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "F", "U": "D", "L": "R", "R": "L", "D": "U", "B": "B"])
        XCTAssertEqual(sut.solver.convert(instructions: "U2 "), "LBRMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "B", "U": "D", "L": "L", "R": "R", "D": "U", "B": "F"])
    }
    
    func testU2Prime() {
        //checking each individual conversion
        XCTAssertEqual(sut.solver.convert(instructions: "U2' "), "TMTMRBLMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "F", "U": "D", "L": "R", "R": "L", "D": "U", "B": "B"])
        XCTAssertEqual(sut.solver.convert(instructions: "U2' "), "RBLMC")
        XCTAssertEqual(sut.solver.referenceFrame, ["F": "B", "U": "D", "L": "L", "R": "R", "D": "U", "B": "F"])
    }
    
    func testError() {
        //checking each individual conversion
        //XCTAssertEqual(sut.solver.convert(instructions: "U QRX "), "unknow movment: QRX")
    }

}
