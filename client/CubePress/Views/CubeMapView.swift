//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeMapModel {
    var top: CubeFaceView
    var front: CubeFaceView
    var left: CubeFaceView
    var right: CubeFaceView
    var bottom: CubeFaceView
    var back: CubeFaceView
}

struct CubeMapView: View {
    //let model: CubeMapModel
    
    var body: some View {
        Grid{
            GridRow{
                Color.white
                //top
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                Color.white
            }
            GridRow{
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                //front 3 sides
            }
            GridRow{
                Color.white
                //bottom
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                Color.white
            }
            GridRow{
                Color.white
                //back
                CubeFaceView(model: CubeFaceModel(pictureString: "rubik"))
                Color.white
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var previews: some View {
        CubeMapView()
    }
}
