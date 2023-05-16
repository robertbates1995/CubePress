//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI


//abstract into cubemapmodel file

struct CubeMapView: View {
    @ObservedObject var model: CubeMapModel
    
    var body: some View {
        Grid{
            GridRow{
                Color.white
                //Up
                CubeFaceView(model: model.U, faceLabel: "Up")
                Color.white
            }
            GridRow{
                CubeFaceView(model: model.L, faceLabel: "Left")
                CubeFaceView(model: model.F, faceLabel: "Front")
                CubeFaceView(model: model.R, faceLabel: "Right")
                //front 3 sides
            }
            GridRow{
                Color.white
                //bottom
                CubeFaceView(model: model.D, faceLabel: "Down")
                Color.white
            }
            GridRow{
                Color.white
                //back
                CubeFaceView(model: model.B, faceLabel: "Back")
                Color.white
            }
        }
        .aspectRatio(contentMode: .fit)
        .padding()
    }
    
    struct CubeFaceView: View {
        var model: Face
        var faceLabel: String
        
        var body: some View {
            VStack{
                Grid {
                    GridRow{
                        //zstack here
                        Color(model.topLeft)
                        Color(model.topCenter)
                        Color(model.topRight)
                    }
                    GridRow{
                        Color(model.midLeft)
                        Color(model.midCenter)
                        Color(model.midRight)
                    }
                    GridRow{
                        Color(model.bottomLeft)
                        Color(model.bottomCenter)
                        Color(model.bottomRight)
                    }
                }
                .aspectRatio(contentMode: .fit)
                Text(faceLabel)
            }
        }
    }
    
    struct ColorSelectView: View {
        var colorSelected: Color
        
        var body: some View {
            HStack{
                Text("test")
            }
        }
    }
}


struct CubeMapView_Previews: PreviewProvider {
    static var previews: some View {
        CubeMapView(model: CubeMapModel())
    }
}
