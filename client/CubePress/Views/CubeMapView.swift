//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeMapView: View {
    
    // this is a member function that takes and returns nothing
    // it initiates the solving sequence
    let onSolveTapped: () -> ()
    
    @ObservedObject var model: CubeMapModel
    
    var body: some View {
        VStack{
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
            .padding([.leading, .trailing])
            HStack{
                Button("Solve") {
                    onSolveTapped()
                }
                .shadow(radius: 5)
                .padding()
                .background(.gray)
                .foregroundColor(.black)
                .font(.title)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .padding()
            }
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
        CubeMapView(onSolveTapped: {}, model: model)
    }
}
