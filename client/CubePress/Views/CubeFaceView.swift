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
                    FaceletView(facelet: $model.topLeft)
                    FaceletView(facelet: $model.topCenter)
                    FaceletView(facelet: $model.topRight)
                }
                GridRow {
                    FaceletView(facelet: $model.midLeft)
                    FaceletView(facelet: $model.midCenter)
                    FaceletView(facelet: $model.midRight)
                }
                GridRow {
                    FaceletView(facelet: $model.bottomLeft)
                    FaceletView(facelet: $model.bottomCenter)
                    FaceletView(facelet: $model.bottomRight)
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
    @Binding var facelet: Facelet?
    @State var showingSheet = false
    
    var body: some View {
        Button(
            action: {showingSheet.toggle()},
            label: { Image(uiImage: facelet?.image ?? UIImage(named: "fourColors")!).resizable() }
        )
        .border(Color(uiColor: facelet?.cubeFace.color ?? .white), width: 3)
        .sheet(isPresented: $showingSheet) {SheetView(selectedColor: $facelet)}
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColor: Facelet?
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {selectedColor?.cubeFace = .L
                    dismiss()
                }, label: {Circle().fill(.red)})
                Button(action: {selectedColor?.cubeFace = .F
                    dismiss()
                }, label: {Circle().fill(.blue)})
                Button(action: {selectedColor?.cubeFace = .B
                    dismiss()
                }, label: {Circle().fill(.green)})
            }
            HStack{
                Button(action: {selectedColor?.cubeFace = .R
                    dismiss()
                }, label: {Circle().fill(.orange)})
                Button(action: {selectedColor?.cubeFace = .D
                    dismiss()
                }, label: {Circle().fill(.yellow)})
                Button(action: {selectedColor?.cubeFace = .U
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
    static var model = Face(
        topLeft: Facelet(cubeFace: .U),
        topCenter: Facelet(cubeFace: .F),
        topRight: Facelet(cubeFace: .L),
        bottomLeft: Facelet(cubeFace: .B)
    )
    
    static var previews: some View {
        CubeFaceView(model: Binding(get: { model }, set: { model = $0 }), faceLabel: "test face")
    }
}
