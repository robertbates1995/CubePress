//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeMapView: View {
    @ObservedObject var model: CubeMapModel
    @State private var selection: Int = 1
    var body: some View {
        VStack{
            GeometryReader{ geometry in
                Grid(horizontalSpacing: 20) {
                    GridRow{
                        //Up
                        Spacer()
                        CubeFaceView(model: $model.U, faceLabel: "U")
                    }
                    GridRow{
                        //front 3 sides
                        CubeFaceView(model: $model.L, faceLabel: "L")
                        CubeFaceView(model: $model.F, faceLabel: "F")
                        CubeFaceView(model: $model.R, faceLabel: "R")
                    }
                    GridRow{
                        //bottom
                        Spacer()
                        CubeFaceView(model: $model.D, faceLabel: "D")
                    }
                    GridRow{
                        //back
                        Spacer()
                        CubeFaceView(model: $model.B, faceLabel: "B")
                    }
                }
                .frame(width: geometry.size.width)
            }
            .padding([.leading, .trailing])
            HStack(alignment: .center){
                movementButtonStack("D")
                movementButtonStack("U")
                movementButtonStack("L")
                movementButtonStack("R")
                movementButtonStack("F")
                movementButtonStack("B")
            }
        }
        .padding([.leading, .trailing])
        .background(.mint)
    }
    
    func movementButtonStack(_ move: String) -> some View {
        VStack(alignment: .center) {
            Button(move) {
                model.move(to: move)
            }.foregroundColor(.black)
            Button("\(move)'") {
                model.move(to: move)
            }.foregroundColor(.black)
        }
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var model: CubeMapModel {
        let temp = CubeMapModel()
        temp.move(to: "F")
        return temp
    }
    
    static var previews: some View {
        CubeMapView(model: model)
    }
}
