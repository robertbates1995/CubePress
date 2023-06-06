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
            CubeFaceView(model: Binding(get: { model.U }, set: {model.U = $0}), faceLabel: "U")
            CubeFaceView(model: Binding(get: { model.L }, set: {model.L = $0}), faceLabel: "L")
            CubeFaceView(model: Binding(get: { model.F }, set: {model.F = $0}), faceLabel: "F")
            CubeFaceView(model: Binding(get: { model.R }, set: {model.R = $0}), faceLabel: "R")
            CubeFaceView(model: Binding(get: { model.D }, set: {model.D = $0}), faceLabel: "D")
            CubeFaceView(model: Binding(get: { model.B }, set: {model.B = $0}), faceLabel: "B")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing, .bottom])
        .background(.mint)
    }
    
    var FullMapView: some View {
        VStack{
            Grid(horizontalSpacing: 30){
                GridRow{
                    Color.mint
                    //Up
                    //                    CubeFaceView(model: model.U, faceLabel: "Up")
                }
                GridRow{
                    //                    CubeFaceView(model: model.L, faceLabel: "Left")
                    //                    CubeFaceView(model: model.F, faceLabel: "Front")
                    //                    CubeFaceView(model: model.R, faceLabel: "Right")
                    //front 3 sides
                }
                GridRow{
                    Color.mint
                    //bottom
                    //                    CubeFaceView(model: model.D, faceLabel: "Down")
                }
                GridRow{
                    Color.mint
                    //back
                    //                    CubeFaceView(model: model.B, faceLabel: "Back")
                }
            }
            HStack(alignment: .center) {
                Spacer()
                Button("Save test strips") {
                    model.saveTestStrips()
                }.foregroundColor(.black)
                Spacer()
                Button("Update Colors") {
                    model.updateColors()
                }.foregroundColor(.black)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding([.leading, .trailing, .bottom])
        .background(.mint)
    }
}

struct CubeMapView_Previews: PreviewProvider {
    static var model: CubeMapModel {
        let temp = CubeMapModel()
        temp.F.sourceImages = Array(repeating: UIImage(named: "blueSample")!, count: 9)
        temp.L.sourceImages = Array(repeating: UIImage(named: "redSample")!, count: 9)
        temp.R.sourceImages = Array(repeating: UIImage(named: "orangeSample")!, count: 9)
        temp.U.sourceImages = Array(repeating: UIImage(named: "whiteSample")!, count: 9)
        temp.B.sourceImages = Array(repeating: UIImage(named: "greenSample")!, count: 9)
        temp.D.sourceImages = Array(repeating: UIImage(named: "yellowSample")!, count: 9)
        temp.updateColors()
        return temp
    }
    
    static var previews: some View {
        CubeMapView(model: model)
    }
}
