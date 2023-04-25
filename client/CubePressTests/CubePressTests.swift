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
    let sut = SettingsModel()
    let incoming = "{\"center\": 1550000, \"right\": 47, \"bot\": 1600000, \"left\": 3000000, \"top\": 750000, \"mid\": 1230000}"
    let expected = [Move.center: "1550000", .right: "47", .bot: "1600000", .left: "3000000", .top: "750000", .mid: "1230000"]
    
    func testBinding() throws {
        let binding = sut.binding(for: .top)
        XCTAssertEqual(sut.settings, [:])
        XCTAssertEqual(binding.wrappedValue, "")
        binding.wrappedValue = "42"
        XCTAssertEqual(sut.settings, [.top: "42"])
        XCTAssertEqual(binding.wrappedValue, "42")
        let centerBinding = sut.binding(for: .center)
        centerBinding.wrappedValue = "47"
        XCTAssertEqual(sut.settings, [.center: "47", .top: "42"])
        XCTAssertEqual(centerBinding.wrappedValue, "47")
    }
    
    func testConversion() throws {
        let data = try XCTUnwrap(incoming.data(using:.utf8))
        sut.processData(data)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.settings, expected)
    }
    
    func testCalcColor(picture: String, color: UIColor) {
        let image = UIImage(named: picture, in: Bundle(for: CubePressTests.self), with: nil)!
        let sut = ColorFinder()
        XCTAssertEqual(sut.calcColor(image: CIImage(image: image)!), color)
    }
    
    func testAllColors() {
        testCalcColor(picture: "orangeSample", color: .orange)
        testCalcColor(picture: "blueSample", color: .blue)
        testCalcColor(picture: "greenSample", color: .green)
        testCalcColor(picture: "yellowSample", color: .yellow)
        testCalcColor(picture: "redSample", color: .red)
        testCalcColor(picture: "whiteSample", color: .white)
    }
    
    func testCubeMap(map: String, _ expected: String) {
        let tmp = FileManager.default.temporaryDirectory.path
        let solutionPtr = ApplyKociembaAlgorithm(strdup(map), 25000, 500, 0, tmp)
        if let solutionPtr {
            let solution = String(cString: solutionPtr)
            XCTAssertEqual(solution, expected)
        } else {
            print("no solution to map: \(map)")
        }
    }

    func testKociembaSolver() {
        let solvedMap = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB"
        testCubeMap(map: solvedMap, "R L U2 R L\' B2 U2 R2 F2 L2 D2 L2 F2 ")
    }
}
