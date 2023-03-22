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
    @Published var orange =  CubeFace()
    @Published var white =  CubeFace()
    @Published var green =  CubeFace()
    @Published var yellow =  CubeFace()
    @Published var blue =  CubeFace()
    @Published var red =  CubeFace()
    
    func add(face: CubeFace) {
        //add face based on center color
        switch face.midCenter {
        case .orange:
            orange = face
        case .white:
            white = face
        case .green:
            green = face
        case .yellow:
            yellow = face
        case .blue:
            blue = face
        case .red:
            red = face
        default:
            break
        }
    }
}

struct CubeFace {
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
