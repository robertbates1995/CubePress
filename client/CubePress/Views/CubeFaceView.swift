//
//  CubeFaceView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

struct CubeFaceView: View {
    let row: [Color] = [Color(.red), Color(.blue), Color(.green)]
    
    var body: some View {
        Grid {
            GridRow{
                row[0]
                row[1]
                row[2]
            }
            GridRow{
                Color(.red)
                Color(.blue)
                Color(.green)
            }
            GridRow{
                Color(.red)
                Color(.blue)
                Color(.green)
            }
        }
        .aspectRatio(contentMode: .fit)
    }
}

struct CubeFaceView_Previews: PreviewProvider {
    static var previews: some View {
        CubeFaceView()
    }
}
