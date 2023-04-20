//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation
import KociembaSolver

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
    var solution = ""
    
    init(getter: CubeFaceGetter, cubeMover: CubeMovable, cubeMap: CubeMapModel) {
        self.getter = getter
        self.cubeMover = cubeMover
        self.cubeMap = cubeMap
    }
    
    fileprivate func scanFace(_ cubeMap: CubeMapModel, move: Move) async throws {
        try await cubeMover.move(to: move)
        await cubeMap.add(face: getter.cubeFace)
    }
    
    //TODO: Cube faces are being scanned in upside-down
    func scanCube() async throws {
        //set robot to starting posistion
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .mid)
        //Scan
        await MainActor.run(body: {
            cubeMap.F = getter.cubeFace
        })
        try await cubeMover.move(to: .right)
        await MainActor.run(body: {
            cubeMap.R = getter.cubeFace
        })
        try await cubeMover.move(to: .left)
        await MainActor.run(body: {
            cubeMap.L = getter.cubeFace
        })
        try await cubeMover.move(to: .center)
        try await cubeMover.move(to: .top)
        try await cubeMover.move(to: .mid)
        await MainActor.run(body: {
            cubeMap.U = getter.cubeFace
        })
        try await cubeMover.move(to: .top)
        try await cubeMover.move(to: .mid)
        await MainActor.run(body: {
            cubeMap.B = getter.cubeFace
        })
        try await cubeMover.move(to: .top)
        try await cubeMover.move(to: .mid)
        await MainActor.run(body: {
            cubeMap.D = getter.cubeFace
        })
    }
    
    fileprivate func convert(face: Facelet) -> String {
        var product = ""
        
        return product
    }
    
    fileprivate func convert(instructions: String) -> String {
        var product = ""
        
        return product
    }
    
    fileprivate func convertMap() async -> String {
        await MainActor.run(body: {
            var product = ""
            product += convert(face: cubeMap.U)
            return product
        })
    }
    
    func solveCube() async throws {
        //DONT TAP THE BUTTON TWICE
        try await scanCube()
        let tmp = FileManager.default.temporaryDirectory.path
        let configuration = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB"
        let solutionPtr = ApplyKociembaAlgorithm(strdup(configuration), 25000, 500, 0, tmp) //replace configuration with convertMap()
        if let solutionPtr {
            let solution = String(cString: solutionPtr)
            print(solution)
        } else {
            print("no solution")
        }
    }
}
