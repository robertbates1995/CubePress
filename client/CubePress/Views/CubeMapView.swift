//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeMapView: View {
    
    let onScanTapped: () -> ()
    
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
            Button("Solve") {
                onScanTapped()
            }
            .padding()
            .background(.gray)
            .foregroundColor(.black)
            .font(.title)
            .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
            .padding()
//            HStack(alignment: .center){
//                movementButtonStack("D")
//                movementButtonStack("U")
//                movementButtonStack("L")
//                movementButtonStack("R")
//                movementButtonStack("F")
//                movementButtonStack("B")
//            }
        }
        .padding([.leading, .trailing])
        .background(.black)
    }
    
    func movementButtonStack(_ move: String) -> some View {
        VStack(alignment: .center) {
            Button {
                model.move(to: move)
            } label: {
                Text(move)
                    .padding()
            }
            Button {
                model.move(to: "\(move)'")
            }label: {
                Text("\(move)'")
                    .padding()
            }
        }.foregroundColor(.white)
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var model: CubeMapModel {
        let temp = CubeMapModel()
        return temp
    }
    
    static var previews: some View {
        CubeMapView(onScanTapped: {}, model: model)
    }
}
