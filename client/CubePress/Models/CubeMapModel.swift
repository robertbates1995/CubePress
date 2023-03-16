//
//  CubeMapModel.swift
//  CubePress
//
//  Created by Robert Bates on 3/15/23.
//

import Foundation

//needs to look at a published property, cubeFace, in frame model.  will hand this model the property that it needs
//needs to be made observable

struct CubeMapModel {
        var orange =  CubeFaceModel()
        var white =  CubeFaceModel()
        var green =  CubeFaceModel()
        var yellow =  CubeFaceModel()
        var blue =  CubeFaceModel()
        var red =  CubeFaceModel()
}
