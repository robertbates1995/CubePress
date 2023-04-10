//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation

protocol CubeMovable: AnyObject {
    func move(to: Move) async throws
}

protocol CubeFaceGetter {
    var cubeFace: Facelet{ get }
}

class Solver {
    let getter: CubeFaceGetter
    var cubeMover: CubeMovable
    var cubeMap: CubeMapModel
    
    init(getter: CubeFaceGetter, cubeMover: CubeMovable, cubeMap: CubeMapModel) {
        self.getter = getter
        self.cubeMover = cubeMover
        self.cubeMap = cubeMap
    }
    
    fileprivate func scanFace(_ cubeMap: CubeMapModel, move: Move) async throws {
        try await cubeMover.move(to: move)
        await cubeMap.add(face: getter.cubeFace)
    }
    
    func scanCube() async throws {
        //set robot to starting posistion
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .mid)
        //Scan
        await cubeMap.add(face: getter.cubeFace)
        try await scanFace(cubeMap, move: .right)
        try await scanFace(cubeMap, move: .left)
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
    }
    
    func solveCube() async throws {
        //DONT TAP THE BUTTON TWICE
        try await scanCube()
        //TODO: solveCube()
    }
}
