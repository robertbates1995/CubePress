//
//  CubeFaceView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI



struct CubeFaceView: View {
    var model: CubeFace
    
    var body: some View {
        Grid {
            GridRow{
                Color(model.topLeft)
                Color(model.topCenter)
                Color(model.topRight)
            }
            GridRow{
                Color(model.midLeft)
                Color(model.midCenter)
                Color(model.midRight)
            }
            GridRow{
                Color(model.bottomLeft)
                Color(model.bottomCenter)
                Color(model.bottomRight)
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CubeFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CubeFaceView(model: .init())
    }
}
