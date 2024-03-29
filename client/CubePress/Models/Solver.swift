//
//  solver.swift
//  CubePress
//
//  Created by Robert Bates on 3/17/23.
//

import Foundation
import KociembaSolver
import UIKit

protocol CubeFaceGetter {
    var cubeFace: Face{ get }
}

enum SolverError: Error {
    case noSolution
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
        try await cubeMover.input(move: "CM" )  //set robot to starting posistion
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {cubeMap.F = getter.cubeFace} ) //Scan
        try await cubeMover.input(move: "R" )
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {cubeMap.R = getter.cubeFace} )
        try await cubeMover.input(move: "L" )
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {cubeMap.L = getter.cubeFace} )
        try await cubeMover.input(move: "CTM" )
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {cubeMap.U = getter.cubeFace} )
        try await cubeMover.input(move: "TM" )
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {
            cubeMap.B.sourceImages = getter.cubeFace.sourceImages.reversed()
            cubeMap.B.topEdge = getter.cubeFace.bottomEdge
            cubeMap.B.bottomEdge = getter.cubeFace.topEdge
            cubeMap.B.midCenter = getter.cubeFace.midCenter
            cubeMap.B.midLeft = getter.cubeFace.midRight
            cubeMap.B.midRight = getter.cubeFace.midLeft
        } ) //this one needs to be reversed because the face is being scanned backwards
        try await cubeMover.input(move: "TM" )
        try await Task.sleep( nanoseconds: 2_000_000_000 )
        await MainActor.run(body: {cubeMap.D = getter.cubeFace})
        //func that sends an array of centers to framemodel
        //update cubeMap
        await MainActor.run(body: {
            cubeMap.U.updateFacelets(with: cubeMap.centers)
            cubeMap.R.updateFacelets(with: cubeMap.centers)
            cubeMap.L.updateFacelets(with: cubeMap.centers)
            cubeMap.B.updateFacelets(with: cubeMap.centers)
            cubeMap.D.updateFacelets(with: cubeMap.centers)
            cubeMap.F.updateFacelets(with: cubeMap.centers)
        })
        try await cubeMover.input(move: "TM" )

    }
    
    fileprivate func convert(color: CubeFace?) -> String {
        color?.rawValue ?? "[error in convert(color: UIColor)]"
    }
    
    fileprivate func convert(face: Face) -> String {
        var product = convert(color: face.topLeft?.cubeFace)
        product += convert(color: face.topCenter?.cubeFace)
        product += convert(color: face.topRight?.cubeFace)
        product += convert(color: face.midLeft?.cubeFace)
        product += convert(color: face.midCenter?.cubeFace)
        product += convert(color: face.midRight?.cubeFace)
        product += convert(color: face.bottomLeft?.cubeFace)
        product += convert(color: face.bottomCenter?.cubeFace)
        product += convert(color: face.bottomRight?.cubeFace)
        return product
    }
    
    //TODO: Correct Reference frame conversion
    fileprivate func convertFrameWith(move: String) {
        switch move {
        case "U" :
            rotateForward()
            rotateForward()
        case "R" :
            rotateRight()
            rotateForward()
            rotateLeft()
        case "L" :
            rotateLeft()
            rotateForward()
            rotateRight()
        case "B" :
            rotateBackward()
        case "F" :
            rotateForward()
        case " " :
            rotateRight()
        case "'" :
            rotateLeft()
        default:
            return
        }
    }
    
    fileprivate func rotateForward() {
        let temp = referenceFrame["U"]
        referenceFrame["U"] = referenceFrame["B"]
        referenceFrame["B"] = referenceFrame["D"]
        referenceFrame["D"] = referenceFrame["F"]
        referenceFrame["F"] = temp
    }
    
    fileprivate func rotateBackward() {
        rotateForward()
        rotateForward()
        rotateForward()
    }
    
    fileprivate func rotateRight() {
        let temp = referenceFrame["F"]
        referenceFrame["F"] = referenceFrame["R"]
        referenceFrame["R"] = referenceFrame["B"]
        referenceFrame["B"] = referenceFrame["L"]
        referenceFrame["L"] = temp
    }
    
    fileprivate func rotateLeft() {
        rotateRight()
        rotateRight()
        rotateRight()
    }
    
    func convert(instruction: String) -> String {
        guard let cubeMove = referenceFrame.key(from: instruction[0]),
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
        case "2", "2'" : //if double or prime double
            let move = macro + "LBRMC"
            convertFrameWith(move: cubeMove)
            convertFrameWith(move: " ")
            convertFrameWith(move: " ")
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
        if var instructions = await applyKociembaSolver(facelets: convertMap()) {
            if instructions.last == "'" {
                instructions = String(instructions.dropLast(2))
            }
            let solutionArray = convert(instructions: instructions)
            //slice last item (which is empty) off solutionArray
            //translate Kociemba instructions to valid inputs
            try await cubeMover.input(moves: solutionArray)
        } else {
            let mapString = await convertMap()
            throw SolverError.noSolution
        }
    }
}

extension String {
    subscript(i: Int) -> String {
        return  i < count ? String(self[index(startIndex, offsetBy: i)]) : ""
    }
}

extension Dictionary where Value: Equatable {
    func key(from value: Value) -> Key? {
        return self.first(where: { $0.value == value })?.key
    }
}

struct Delay {

    @discardableResult
    init(_ timeInterval: TimeInterval, queue: DispatchQueue = .main, executingBlock: @escaping () -> Void) {
        queue.asyncAfter(deadline: .now() + timeInterval, execute: executingBlock)
    }

}
