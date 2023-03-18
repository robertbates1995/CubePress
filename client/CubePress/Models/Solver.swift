//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation

protocol CubeMovable: AnyObject {
    func move(to: Moves) async throws
}

protocol CubeFaceGetter {
    var cubeFace: CubeFace{ get }
}

class Solver {
    let getter: CubeFaceGetter
    var cubeMover: CubeMovable
    var task: Task<Void, Never>?
    
    init(getter: CubeFaceGetter, cubeMover: CubeMovable, task: Task<Void, Never>? = nil) {
        self.getter = getter
        self.cubeMover = cubeMover
        self.task = task
    }
    
    fileprivate func scanFace(_ cubeMap: CubeMapModel, move: Moves) async throws {
        try await cubeMover.move(to: move)
        cubeMap.add(face: getter.cubeFace)
    }
    
    func scanCube() async throws -> CubeMapModel {
        //make model to return
        let cubeMap = CubeMapModel()
        cubeMover = SettingsModel()
        //set robot to starting posistion
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .mid)
        //move and scan
        cubeMap.add(face: getter.cubeFace)
        try await scanFace(cubeMap, move: .right)
        try await scanFace(cubeMap, move: .left)
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
        try await cubeMover.move(to: .top)
        try await scanFace(cubeMap, move: .mid)
        return cubeMap
        //create map
        //take picture of side
        //log pic
        //add to map
        //rotate
        //...
        //return cubeMap
        
    }
    
    func solveCube() {
        //DONT TAP THE BUTTON TWICE
        //guard task == nil else {return}
        //guard task?.isCancelled == true else {return}
        task = Task {
            do {
                let cubeMap = try await scanCube()
            } catch {
                print(error)
            }
        }
    }
}
