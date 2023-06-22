//
//  CubeFaceView.swift
//  CubePress
//
//  Created by Robert Bates on 6/5/23.
//

import SwiftUI

struct CubeFaceView: View {
    @Binding var model: Face
    var faceLabel: String
    
    var body: some View {
        VStack{
            Grid {
                GridRow {
                    FaceletView(selectedColor: $model.topLeft)
                        .border(Color(uiColor: model.topLeft.color), width: 3)
                    FaceletView(selectedColor: $model.topCenter)
                        .border(Color(uiColor: model.topCenter.color), width: 3)
                    FaceletView(selectedColor: $model.topRight)
                        .border(Color(uiColor: model.topRight.color), width: 3)
                }
                GridRow {
                    FaceletView(selectedColor: $model.midLeft)
                        .border(Color(uiColor: model.midLeft.color), width: 3)
                    FaceletView(selectedColor: $model.midCenter)                        .border(Color(uiColor: model.midCenter.color), width: 3)
                    FaceletView(selectedColor: $model.midRight)                        .border(Color(uiColor: model.midRight.color), width: 3)
                }
                GridRow {
                    FaceletView(selectedColor: $model.bottomLeft)                        .border(Color(uiColor: model.bottomLeft.color), width: 3)
                    FaceletView(selectedColor: $model.bottomCenter)                        .border(Color(uiColor: model.bottomCenter.color), width: 3)
                    FaceletView(selectedColor: $model.bottomRight)                        .border(Color(uiColor: model.bottomRight.color), width: 3)
                }
            }
            .aspectRatio(contentMode: .fit)
            Text(faceLabel)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    func sourceImage(index: Int) -> some View {
        if model.sourceImages.count < 9 {
            Color.black
        }
        else {
            Image(uiImage: model.sourceImages[index])
                .resizable()
                .frame(idealWidth: .greatestFiniteMagnitude, idealHeight: .greatestFiniteMagnitude)
                .aspectRatio(1.0, contentMode: .fit)
        }
    }
}

struct FaceletView: View {
    @Binding var selectedColor: CubeFace?
    @State var showingSheet = false
    
    var body: some View {
        Button(action: {showingSheet.toggle()}, label: {Color(uiColor: selectedColor.color)})
            .sheet(isPresented: $showingSheet) {SheetView(selectedColor: $selectedColor)}
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColor: CubeFace?
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {selectedColor = .L
                    dismiss()
                }, label: {Circle().fill(.red)})
                Button(action: {selectedColor = .F
                    dismiss()
                }, label: {Circle().fill(.blue)})
                Button(action: {selectedColor = .B
                    dismiss()
                }, label: {Circle().fill(.green)})
            }
            HStack{
                Button(action: {selectedColor = .R
                    dismiss()
                }, label: {Circle().fill(.orange)})
                Button(action: {selectedColor = .D
                    dismiss()
                }, label: {Circle().fill(.yellow)})
                Button(action: {selectedColor = .U
                    dismiss()
                }, label: {Circle().strokeBorder(.black)})
            }
        }
        Button("Press to dismiss") {
            dismiss()
        }
        .font(.title)
        .padding()
    }
}

struct CubeFaceView_Previews: PreviewProvider {
    static var model = Face(topLeft: .U, topCenter: .F, topRight: .L, bottomLeft: .B)
    
    static var previews: some View {
        CubeFaceView(model: Binding(get: { model }, set: { model = $0 }), faceLabel: "test face")
    }
}
