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
            Picker("Select Room Type", selection: self.$selection) {
                Text("View").tag(1)
                Text("Edit").tag(2)
            }
            .frame(width: 300)
            .pickerStyle(.segmented)
            if selection == 1 {
                FullMapView
            } else {
                EditView
            }
        }
    }
    
    var EditView: some View {
        List {
            CubeFaceView(model: $model.U, faceLabel: "U")
            CubeFaceView(model: $model.L, faceLabel: "L")
            CubeFaceView(model: $model.F, faceLabel: "F")
            CubeFaceView(model: $model.R, faceLabel: "R")
            CubeFaceView(model: $model.D, faceLabel: "D")
            CubeFaceView(model: $model.B, faceLabel: "B")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing, .bottom])
        .background(.mint)
    }
    
    var FullMapView: some View {
            VStack{
                GeometryReader{ geometry in
                    Grid(horizontalSpacing: 20) {
                        GridRow{
                            Color.mint
                            //Up
                            CubeFaceView(model: $model.U, faceLabel: "U")
                        }
                        GridRow{
                            //front 3 sides
                            CubeFaceView(model: $model.L, faceLabel: "L")
                            CubeFaceView(model: $model.F, faceLabel: "F")
                            CubeFaceView(model: $model.R, faceLabel: "R")
                        }
                        GridRow{
                            Color.mint
                            //bottom
                            CubeFaceView(model: $model.D, faceLabel: "D")
                        }
                        GridRow{
                            Color.mint
                            //back
                            CubeFaceView(model: $model.B, faceLabel: "B")
                        }
                    }
                    .frame(width: geometry.size.width)
                }
                .padding([.leading, .trailing])
                HStack(alignment: .center) {
                    Spacer()
                    Button("apply D transform") {
                        model.move(to: "D")
                    }.foregroundColor(.black)
                    Spacer()
                    Button("apply D' transform") {
                        model.move(to: "D'")
                    }.foregroundColor(.black)
                    Spacer()
                }
                Spacer()
                HStack(alignment: .center) {
                    Spacer()
                    Button("apply U transform") {
                        model.move(to: "U")
                    }.foregroundColor(.black)
                    Spacer()
                    Button("apply U' transform") {
                        model.move(to: "U'")
                    }.foregroundColor(.black)
                    Spacer()
                }
            }
            .padding([.leading, .trailing])
            .background(.mint)
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
