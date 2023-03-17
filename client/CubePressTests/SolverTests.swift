//
//  SolverTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 3/17/23.
//

import XCTest
@testable import CubePress

class Getter: CubeFaceGetter {
    var cubeFace: CubePress.CubeFace {
        faces.popLast()!
    }
    var faces: [CubeFace]
    
    init(cubeFaces: [CubeFace]) {
        self.faces = cubeFaces
    }
}

class Mover: CubeMovable {
    var movesLoged:[Moves] = []
    
    func move(to move: CubePress.Moves) async {
        movesLoged.append(move)
    }
}

final class SolverTests: XCTestCase {
    func testSolver() async throws {
        let getter = Getter(cubeFaces: [CubeFace(), CubeFace(), CubeFace()])
        let mover = Mover()
        let sut = Solver(getter: getter, cubeMover: mover)
        let result = try await sut.scanCube()
        //testing that the proper moves were performed
        XCTAssertEqual(mover.movesLoged, [.center, .mid, .right]) //empty array is supposed to be the expected array
        //test that colors are accurate
        
        //test all faces have been scanned in
        
        print(result.green)
    }
}
