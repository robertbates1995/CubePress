//
//  CubeFaceView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeFaceModel {
    var colors: [UIColor] = [.green, .red, .blue]
}

struct CubeFaceView: View {
    var model: CubeFaceModel
    
    var body: some View {
        Grid {
            GridRow{
                Color(model.colors[0])
                Color(model.colors[1])
                Color(model.colors[2])
            }
            GridRow{
                Color(model.colors[0])
                Color(model.colors[1])
                Color(model.colors[2])
            }
            GridRow{
                Color(model.colors[0])
                Color(model.colors[1])
                Color(model.colors[2])
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
