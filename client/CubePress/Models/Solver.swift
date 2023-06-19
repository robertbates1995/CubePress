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
    func input(moves: [String]) async throws
}

protocol CubeFaceGetter {
    var cubeFace: Face{ get }
}

class Solver {
    let getter: CubeFaceGetter
    var cubeMover: CubeMovable
    var cubeMap: CubeMapModel
    var referenceFrame = [ "U" : "U",
                           "L" : "L",
                           "F" : "F",
                           "R" : "R",
                           "B" : "B",
                           "D" : "D", ]
    
    init(getter: CubeFaceGetter, cubeMover: CubeMovable, cubeMap: CubeMapModel) {
        self.getter = getter
        self.cubeMover = cubeMover
        self.cubeMap = cubeMap
    }
    
    func scanCube() async throws {
        try await cubeMover.input(moves: ["center", "mid"])  //set robot to starting posistion
        await MainActor.run(body: {cubeMap.U = getter.cubeFace} )  //Scan
        try await cubeMover.input(moves: ["right"])
        await MainActor.run(body: {cubeMap.R = getter.cubeFace} )
        try await cubeMover.input(moves: ["left"])
        await MainActor.run(body: {cubeMap.L = getter.cubeFace} )
        try await cubeMover.input(moves: ["center", "top", "mid"])
        await MainActor.run(body: {cubeMap.B = getter.cubeFace} )
        try await cubeMover.input(moves: ["top", "mid"])
        await MainActor.run(body: {cubeMap.D = getter.cubeFace} )
        try await cubeMover.input(moves: ["top", "mid"])
        await MainActor.run(body: {cubeMap.F = getter.cubeFace} )
        //func that sends an array of centers to framemodel
    }
    
    fileprivate func convert(color: CubeFace?) -> String {
        color?.rawValue ?? "[error in convert(color: UIColor)]"
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
    
    fileprivate func convertFrameWith(move: String) {
        switch move {
        case "U" :
            let tempF = referenceFrame["F"]
            let tempD = referenceFrame["D"]
            referenceFrame["F"] = referenceFrame["B"]
            referenceFrame["D"] = referenceFrame["U"]
            referenceFrame["B"] = tempF
            referenceFrame["U"] = tempD
        case "R" :
            let tempU = referenceFrame["U"]
            referenceFrame["U"] = referenceFrame["L"]
            referenceFrame["L"] = referenceFrame["D"]
            referenceFrame["D"] = referenceFrame["R"]
            referenceFrame["R"] = tempU
        case "L" :
            let tempU = referenceFrame["U"]
            referenceFrame["U"] = referenceFrame["R"]
            referenceFrame["R"] = referenceFrame["D"]
            referenceFrame["D"] = referenceFrame["L"]
            referenceFrame["L"] = tempU
        case "B" :
            let tempU = referenceFrame["U"]
            referenceFrame["U"] = referenceFrame["F"]
            referenceFrame["F"] = referenceFrame["D"]
            referenceFrame["D"] = referenceFrame["B"]
            referenceFrame["B"] = tempU
        case "F" :
            let tempU = referenceFrame["U"]
            referenceFrame["U"] = referenceFrame["L"]
            referenceFrame["L"] = referenceFrame["D"]
            referenceFrame["D"] = referenceFrame["R"]
            referenceFrame["R"] = tempU
        case " " :
            let tempF = referenceFrame["F"]
            referenceFrame["F"] = referenceFrame["R"]
            referenceFrame["R"] = referenceFrame["B"]
            referenceFrame["B"] = referenceFrame["L"]
            referenceFrame["L"] = tempF
        case "'" :
            let tempF = referenceFrame["F"]
            referenceFrame["F"] = referenceFrame["L"]
            referenceFrame["L"] = referenceFrame["B"]
            referenceFrame["B"] = referenceFrame["R"]
            referenceFrame["R"] = tempF
        default:
            return
        }
    }
    
    func convert(instruction: String) -> String {
        guard let cubeMove = referenceFrame[instruction[0]],
              let macro = cubeFace[cubeMove] else { return "no instruction"}
        switch instruction.dropFirst() {
        case "" :    //execute standard move
            let move = macro + "BLMC"
            convertFrameWith(move: cubeMove)
            convertFrameWith(move: " ")
            return move
        case "'" :    //if prime
            let move = macro + "BRMC"
            convertFrameWith(move: cubeMove)
            convertFrameWith(move: "'")
            return move
        case "2" : //if double
            let move = macro + "LBRMC"
            convertFrameWith(move: cubeMove)
            convertFrameWith(move: " ")
            convertFrameWith(move: " ")
            return move
        case "2'" :    //preform prime double version of move
            let move = macro + "RBLMC"
            convertFrameWith(move: cubeMove)
            convertFrameWith(move: "'")
            convertFrameWith(move: "'")
            return move
        default:
            return "error in convert(instruction: String)"
        }
    }
    
    func convert(instructions: String) -> [String] {
        //create dictionary where keys are human moves and values are cubotino moves
        //parse input string
        //convert each element into cubotino equivelent
        var instruction = ""
        var product:[String] = []
        
        for char in instructions {
            if char != " " {
                instruction += String(char)
            } else {
                product.append(convert(instruction: instruction))
                instruction = ""
            }
        }
        return product
    }
    
    func convertMap() async -> String {
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
        //try await scanCube()
        referenceFrame = [ "U" : "U",
                           "L" : "L",
                           "F" : "F",
                           "R" : "R",
                           "B" : "B",
                           "D" : "D", ]
        let tmp = FileManager.default.temporaryDirectory.path
        let solutionPtr = await ApplyKociembaAlgorithm(strdup(convertMap()), 25000, 500, 0, tmp) //convertMap()
        if let solutionPtr {
            var instructions = String(cString: solutionPtr)
            if instructions.last == "'" {
                instructions = String(instructions.dropLast(2))
            }
            let solutionArray = convert(instructions: instructions)
            //slice last item (which is empty) off solutionArray
            //translate Kociemba instructions to valid inputs
            try await cubeMover.input(moves: solutionArray)
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
