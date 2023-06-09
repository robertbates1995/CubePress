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
                GridRow{
                    Facelet(selectedColor: Binding(get: {model.topLeft}, set: {model.topLeft = $0}))
                        .border(Color(uiColor: model.topLeft), width: 3)
                    Facelet(selectedColor: Binding(get: {model.topCenter}, set: {model.topCenter = $0}))
                        .border(Color(uiColor: model.topCenter), width: 3)
                    Facelet(selectedColor: Binding(get: {model.topRight}, set: {model.topRight = $0}))
                        .border(Color(uiColor: model.topRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: $model.midLeft)
                        .border(Color(uiColor: model.midLeft), width: 3)
                    Facelet(selectedColor: $model.midCenter)                        .border(Color(uiColor: model.midCenter), width: 3)
                    Facelet(selectedColor: $model.midRight)                        .border(Color(uiColor: model.midRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: $model.bottomLeft)                        .border(Color(uiColor: model.bottomLeft), width: 3)
                    Facelet(selectedColor: $model.bottomCenter)                        .border(Color(uiColor: model.bottomCenter), width: 3)
                    Facelet(selectedColor: $model.bottomRight)                        .border(Color(uiColor: model.bottomRight), width: 3)
                }
            }
            .aspectRatio(contentMode: .fit)
            Text(faceLabel)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.mint)
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

struct Facelet: View {
    @Binding var selectedColor: UIColor
    @State var showingSheet = false
    
    var body: some View {
        Button(action: {showingSheet.toggle()}, label: {Color(uiColor: selectedColor)})
            .sheet(isPresented: $showingSheet) {SheetView(selectedColor: $selectedColor)}
    }
}

struct SheetView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedColor: UIColor
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {selectedColor = .red
                    dismiss()
                }, label: {Circle().fill(.red)})
                Button(action: {selectedColor = .blue
                    dismiss()
                }, label: {Circle().fill(.blue)})
                Button(action: {selectedColor = .green
                    dismiss()
                }, label: {Circle().fill(.green)})
            }
            HStack{
                Button(action: {selectedColor = .orange
                    dismiss()
                }, label: {Circle().fill(.orange)})
                Button(action: {selectedColor = .yellow
                    dismiss()
                }, label: {Circle().fill(.yellow)})
                Button(action: {selectedColor = .white
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
    static var model = Face(topLeft: .red, topCenter: .blue, topRight: .green, bottomLeft: .yellow)
    
    static var previews: some View {
        CubeFaceView(model: Binding(get: { model }, set: { model = $0 }), faceLabel: "test face")
    }
}
