//
//  SolverTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 3/17/23.
//

import XCTest
@testable import CubePress

//class Getter: CubeFaceGetter {
//    var cubeFace: CubePress.Facelet {
//        faces.popLast()!
//    }
//    var faces: [Facelet]
//
//    init(cubeFaces: [Facelet]) {
//        self.faces = cubeFaces
//    }
//}
//
//class Mover: CubeMovable {
//    var movesLoged:[Move] = []
//
//    func move(to move: CubePress.Move) async {
//        movesLoged.append(move)
//    }
//}
//
//final class SolverTests: XCTestCase {
//    func testSolver() async throws {
//        let getter = Getter(cubeFaces: [Facelet(), Facelet(), Facelet(), Facelet(), Facelet(), Facelet()])
//        let mover = Mover()
//        let sut = await Solver(getter: getter, cubeMover: mover, cubeMap: CubeMapModel())
//        try await sut.scanCube()
//        //testing that the proper moves were performed
//        XCTAssertEqual(mover.movesLoged, [CubePress.Move.center, CubePress.Move.mid, CubePress.Move.right, CubePress.Move.left, CubePress.Move.center, CubePress.Move.top, CubePress.Move.mid, CubePress.Move.top, CubePress.Move.mid, CubePress.Move.top, CubePress.Move.mid]) //empty array is supposed to be the expected array
//        //test that colors are accurate
//        }
//}
