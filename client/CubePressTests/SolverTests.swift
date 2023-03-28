//
//  SolverTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 3/17/23.
//

import XCTest
@testable import CubePress

class Getter: CubeFaceGetter {
    var cubeFace: CubePress.Facelet {
        faces.popLast()!
    }
    var faces: [Facelet]
    
    init(cubeFaces: [Facelet]) {
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
        let getter = Getter(cubeFaces: [Facelet(), Facelet(), Facelet(), Facelet(), Facelet(), Facelet()])
        let mover = Mover()
        let sut = await Solver(getter: getter, cubeMover: mover, cubeMap: CubeMapModel())
        try await sut.scanCube()
        //testing that the proper moves were performed
        XCTAssertEqual(mover.movesLoged, [CubePress.Moves.center, CubePress.Moves.mid, CubePress.Moves.right, CubePress.Moves.left, CubePress.Moves.center, CubePress.Moves.top, CubePress.Moves.mid, CubePress.Moves.top, CubePress.Moves.mid, CubePress.Moves.top, CubePress.Moves.mid]) //empty array is supposed to be the expected array
        //test that colors are accurate
        }
}
