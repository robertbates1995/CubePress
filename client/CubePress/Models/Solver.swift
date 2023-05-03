//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation
import KociembaSolver
import UIKit

protocol CubeMovable: AnyObject {
    func move(to: Move) async throws
}

protocol CubeFaceGetter {
    var cubeFace: Face{ get }
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
        await MainActor.run(body: {
            cubeMap.U = getter.cubeFace
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
            cubeMap.B = getter.cubeFace
        })
        try await cubeMover.move(to: .top)
        try await cubeMover.move(to: .mid)
        await MainActor.run(body: {
            cubeMap.D = getter.cubeFace
        })
        try await cubeMover.move(to: .top)
        try await cubeMover.move(to: .mid)
        await MainActor.run(body: {
            cubeMap.F = getter.cubeFace
        })
    }
    
    fileprivate func convert(color: UIColor) -> String {
        switch color {
        case .white:
            return "U"
        case .green:
            return "R"
        case .orange:
            return "F"
        case .yellow:
            return "D"
        case .red:
            return "B"
        case .blue:
            return "L"
        default:
            return "[error in convert(color: UIColor)]"
        }
    }
    
    fileprivate func convert(face: Face) -> String {
        var product = convert(color: face.topLeft)
        product += convert(color: face.topCenter)
        product += convert(color: face.topRight)
        product += convert(color: face.midLeft)
        product += convert(color: face.midCenter)
        product += convert(color: face.midRight)
        product += convert(color: face.bottomLeft)
        product += convert(color: face.bottomCenter)
        product += convert(color: face.bottomRight)
        return product
    }
    
    func convert(instruction: String) -> String {
        switch instruction.count {  //switch on string length
        case 1 :    //execute standard move
            return MacroMove[instruction]! + "BRMC"
        case 2 :    //determine if prime or double and act accordingly
            if instruction.contains("'") {  //prime case
                return MacroMove[instruction[0]]! + "BLMC"
            } else {    //double case
                return MacroMove[instruction[0]]! + "LBRMC"
            }
        case 3 :    //preform prime double version of move
            return MacroMove[instruction[0]]! + "RBLMC"
        default:
            return "[error in convert(instruction: UIColor)]"
        }
    }
    
    func convert(instructions: String) -> String {
        //create dictionary where keys are human moves and values are cubotino moves
        //parse input string
        //convert each element into cubotino equivelent
        var instruction = ""
        var product = ""
        
        for char in instructions {
            if char != " " {
                instruction += String(char)
            } else {
                product += convert(instruction: instruction)
                //product += MacroMove[instruction]!
                instruction = ""
            }
        }
        return product
    }
    
    fileprivate func convertMap() async -> String {
        await MainActor.run(body: {
            var product = ""
            product += convert(face: cubeMap.U)
            product += convert(face: cubeMap.R)
            product += convert(face: cubeMap.F)
            product += convert(face: cubeMap.D)
            product += convert(face: cubeMap.L)
            product += convert(face: cubeMap.B)
            return product
        })
    }
    
    func solveCube() async throws {
        //DONT TAP THE BUTTON TWICE
        try await scanCube()
        let tmp = FileManager.default.temporaryDirectory.path
        let solutionPtr = await ApplyKociembaAlgorithm(strdup(convertMap()), 25000, 500, 0, tmp)
        if let solutionPtr {
            let solution = String(cString: solutionPtr)
            print(solution)
        } else {
            let mapString = await convertMap()
            print("no solution to map: \(mapString)")
        }
    }
}

extension String {
    subscript(i: Int) -> String {
        return  i < count ? String(self[index(startIndex, offsetBy: i)]) : ""
    }
}
