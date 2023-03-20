//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI


//abstract into cubemapmodel file

struct CubeMapView: View {
    let model: CubeMapModel
    
    var body: some View {
        Grid{
            GridRow{
                Color.white
                //top
                CubeFaceView(model: model.red)
                Color.white
            }
            GridRow{
                CubeFaceView(model: model.yellow)
                CubeFaceView(model: model.blue)
                CubeFaceView(model: model.white)
                //front 3 sides
            }
            GridRow{
                Color.white
                //bottom
                CubeFaceView(model: model.orange)
                Color.white
            }
            GridRow{
                Color.white
                //back
                CubeFaceView(model: model.green)
                Color.white
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var previews: some View {
        CubeMapView(model: CubeMapModel())
    }
}
