//
//  CubeMapModel.swift
//  CubePress
//
//  Created by Robert Bates on 3/15/23.
//

import Foundation
import UIKit

//needs to look at a published property, cubeFace, in frame model.  will hand this model the property that it needs
//needs to be made observable

@MainActor
class CubeMapModel: ObservableObject {
    @Published var U =  Facelet()
    @Published var L =  Facelet()
    @Published var F =  Facelet()
    @Published var R =  Facelet()
    @Published var B =  Facelet()
    @Published var D =  Facelet()
    
    //add function needs to add based on orientation of cube, not color of center square
    func add(face: Facelet) {
        //add face based on center color
        switch face.midCenter {
        case .orange:
            F = face
        case .white:
            U = face
        case .green:
            R = face
        case .blue:
            L = face
        case .red:
            B = face
        case .yellow:
            D = face
        default:
            break
        }
    }
}

struct Facelet {
    //a data structure that represents one face of the rubix cube
    var topLeft = UIColor.black
    var topCenter = UIColor.black
    var topRight = UIColor.black
    var midLeft = UIColor.black
    var midCenter = UIColor.black
    var midRight = UIColor.black
    var bottomLeft = UIColor.black
    var bottomCenter = UIColor.black
    var bottomRight = UIColor.black
}
