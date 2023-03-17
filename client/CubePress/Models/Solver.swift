//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation

protocol CubeMovable {
    func move(to: Moves) async throws
}

protocol CubeFaceGetter {
    var cubeFace: CubeFace{ get }
}

struct Solver {
    let getter: CubeFaceGetter
    let cubeMover: CubeMovable
    
    fileprivate func scanFace(_ cubeMap: CubeMapModel, move: Moves) async throws {
        try await cubeMover.move(to: move)
        cubeMap.add(face: getter.cubeFace)
    }
    
    func scanCube() async throws -> CubeMapModel {
        //make model to return
        let cubeMap = CubeMapModel()
        //set robot to default posistion
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .mid)
        //move and scan
        cubeMap.add(face: getter.cubeFace)
        try await scanFace(cubeMap, move: .right)

        
        return cubeMap
        //create map
        //take picture of side
        //log pic
        //add to map
        //rotate
        //...
        //return cubeMap
        
    }
}
