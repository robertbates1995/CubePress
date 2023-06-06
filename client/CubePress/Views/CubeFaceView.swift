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
                    Facelet(selectedColor: Binding(get: { model.topLeft }, set: { model.topLeft = $0 }))
                        .border(Color(uiColor: model.topLeft), width: 3)
                    Facelet(selectedColor: Binding(get: { model.topCenter }, set: { model.topCenter = $0 }))
                        .border(Color(uiColor: model.topCenter), width: 3)
                    Facelet(selectedColor: Binding(get: { model.topRight }, set: { model.topRight = $0 }))
                        .border(Color(uiColor: model.topRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: Binding(get: { model.midLeft }, set: { model.midLeft = $0 }))
                        .border(Color(uiColor: model.midLeft), width: 3)
                    Facelet(selectedColor: Binding(get: { model.midCenter }, set: { model.midCenter = $0 }))
                        .border(Color(uiColor: model.midCenter), width: 3)
                    Facelet(selectedColor: Binding(get: { model.midRight }, set: { model.midRight = $0 }))
                        .border(Color(uiColor: model.midRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: Binding(get: { model.bottomLeft }, set: { model.bottomLeft = $0 }))
                        .border(Color(uiColor: model.bottomLeft), width: 3)
                    Facelet(selectedColor: Binding(get: { model.bottomCenter }, set: { model.bottomCenter = $0 }))
                        .border(Color(uiColor: model.bottomCenter), width: 3)
                    Facelet(selectedColor: Binding(get: { model.bottomRight }, set: { model.bottomRight = $0 }))
                        .border(Color(uiColor: model.bottomRight), width: 3)
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
    
    var body: some View {
        Picker(selection: self.$selectedColor) {
            Text("Top").tag(UIColor.red)
            Text("Left").tag(UIColor.blue)
            Text("Right").tag(UIColor.green)
            Text("Back").tag(UIColor.yellow)
        } label: {Color(uiColor: selectedColor)}
    }
}

struct CubeFaceView_Previews: PreviewProvider {
    static var model = Face()
    
    static var previews: some View {
        CubeFaceView(model: Binding(get: { model }, set: { model = $0 }), faceLabel: "test face")
    }
}
