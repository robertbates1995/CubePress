//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeMapModel {
    var top =  CubeFaceModel()
    var front =  CubeFaceModel()
    var left =  CubeFaceModel()
    var right =  CubeFaceModel()
    var bottom =  CubeFaceModel()
    var back =  CubeFaceModel()
}

struct CubeMapView: View {
    let model: CubeMapModel
    
    var body: some View {
        Grid{
            GridRow{
                Color.white
                //top
                CubeFaceView(model: model.top)
                Color.white
            }
            GridRow{
                CubeFaceView(model: model.left)
                CubeFaceView(model: model.front)
                CubeFaceView(model: model.right)
                //front 3 sides
            }
            GridRow{
                Color.white
                //bottom
                CubeFaceView(model: model.bottom)
                Color.white
            }
            GridRow{
                Color.white
                //back
                CubeFaceView(model: model.back)
                Color.white
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var previews: some View {
        CubeMapView(model: .init())
    }
}
