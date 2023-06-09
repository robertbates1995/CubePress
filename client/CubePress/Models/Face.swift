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
    
    var centerImage: UIImage? {sourceImages.count > 0 ? sourceImages[4] : nil}
    
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
