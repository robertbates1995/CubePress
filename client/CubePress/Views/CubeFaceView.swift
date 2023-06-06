//
//  CubeFaceView.swift
//  CubePress
//
//  Created by Robert Bates on 6/5/23.
//

import SwiftUI

struct CubeFaceView: View {
    @Binding var model: Face
    @State private var showingSheet = false
    var faceLabel: String
    
    var body: some View {
        VStack{
            Grid {
                GridRow{
                    Facelet(selectedColor: $model.topLeft, showingSheet: $showingSheet)
                        .border(Color(uiColor: model.topLeft), width: 3)
                    Facelet(selectedColor: $model.topCenter, showingSheet: $showingSheet)                        .border(Color(uiColor: model.topCenter), width: 3)
                    Facelet(selectedColor: $model.topRight, showingSheet: $showingSheet)                        .border(Color(uiColor: model.topRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: $model.midLeft, showingSheet: $showingSheet)                        .border(Color(uiColor: model.midLeft), width: 3)
                    Facelet(selectedColor: $model.midCenter, showingSheet: $showingSheet)                        .border(Color(uiColor: model.midCenter), width: 3)
                    Facelet(selectedColor: $model.midRight, showingSheet: $showingSheet)                        .border(Color(uiColor: model.midRight), width: 3)
                }
                GridRow{
                    Facelet(selectedColor: $model.bottomLeft, showingSheet: $showingSheet)                        .border(Color(uiColor: model.bottomLeft), width: 3)
                    Facelet(selectedColor: $model.bottomCenter, showingSheet: $showingSheet)                        .border(Color(uiColor: model.bottomCenter), width: 3)
                    Facelet(selectedColor: $model.bottomRight, showingSheet: $showingSheet)                        .border(Color(uiColor: model.bottomRight), width: 3)
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
    @Binding var showingSheet: Bool
    
    var body: some View {
        Button(action: {}, label: {Color(uiColor: selectedColor)})
    }
}

struct CubeFaceView_Previews: PreviewProvider {
    static var model = Face()
    
    static var previews: some View {
        CubeFaceView(model: Binding(get: { model }, set: { model = $0 }), faceLabel: "test face")
    }
}
