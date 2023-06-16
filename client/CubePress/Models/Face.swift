//
//  Face.swift
//  CubePress
//
//  Created by Robert Bates on 6/9/23.
//

import Foundation
import UIKit

struct Face {
    //a data structure that represents one face of the rubix cube
    var sourceImages: [UIImage] = []
    var topLeft: CubeFace?
    var topCenter: CubeFace?
    var topRight: CubeFace?
    var midLeft: CubeFace?
    var midCenter: CubeFace?
    var midRight: CubeFace?
    var bottomLeft: CubeFace?
    var bottomCenter: CubeFace?
    var bottomRight: CubeFace?
    
    var topEdge: [CubeFace?] {
        get { [topLeft, topCenter, topRight] }
        set(newEdge){
            topLeft = newEdge[0]
            topCenter = newEdge[1]
            topRight = newEdge[2]
        }
    }
    var rightEdge: [CubeFace?] {
        get { [topRight, midRight, bottomRight] }
        set(newEdge) {
            topRight = newEdge[0]
            midRight = newEdge[1]
            bottomRight = newEdge[2]
        }
    }
    var leftEdge: [CubeFace?] {
        get { [bottomLeft, midLeft, topLeft] }
        set(newEdge) {
            bottomLeft = newEdge[0]
            midLeft = newEdge[1]
            topLeft = newEdge[2]
        }
    }
    var bottomEdge: [CubeFace?] {
        get { [bottomRight, bottomCenter, bottomLeft] }
        set (newEdge){
            bottomRight = newEdge[0]
            bottomCenter = newEdge[1]
            bottomLeft = newEdge[2]
        }
    }

    var centerImage: UIImage? {sourceImages.count > 0 ? sourceImages[4] : nil}
    
    mutating func rotateClockwise() {
        let temp = topEdge
        topEdge = leftEdge
        leftEdge = bottomEdge
        bottomEdge = rightEdge
        rightEdge = temp
    }
    
    mutating func rotateCounterClockwise() {
        rotateClockwise()
        rotateClockwise()
        rotateClockwise()
    }
    
    mutating func updateColors(with centers: [UIImage]) {
        let finder = ColorFinder()
        topLeft = finder.calcColor(image: sourceImages[6], base: centers)
        topCenter = finder.calcColor(image: sourceImages[7], base: centers)
        topRight = finder.calcColor(image: sourceImages[8], base: centers)
        midLeft = finder.calcColor(image: sourceImages[3], base: centers)
        midCenter = finder.calcColor(image: sourceImages[4], base: centers)
        midRight = finder.calcColor(image: sourceImages[5], base: centers)
        bottomLeft = finder.calcColor(image: sourceImages[0], base: centers)
        bottomCenter = finder.calcColor(image: sourceImages[1], base: centers)
        bottomRight = finder.calcColor(image: sourceImages[2], base: centers)
    }
}

enum CubeFace: String, CaseIterable, Identifiable, Codable, Hashable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

extension Optional<CubeFace> {
    var color: UIColor {
        switch self {
            
        case .none:
            return .black
        case .some( let value ):
            return value.color
        }
    }
}

extension CubeFace {
    var color: UIColor{
        switch self {
        case .U:
            return .white
        case .D:
            return .yellow
        case .R:
            return .orange
        case .L:
            return .red
        case .F:
            return .blue
        case .B:
            return .green
        }
    }
}

extension Face {
    init(face: CubeFace?) {
        topLeft = face
        topCenter = face
        topRight = face
        midLeft = face
        midCenter = face
        midRight = face
        bottomLeft = face
        bottomCenter = face
        bottomRight = face
    }
}
