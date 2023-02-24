//
//  MyShape.swift
//  CubePress
//
//  Created by Robert Bates on 2/24/23.
//

import Foundation
import SwiftUI

struct MyShape: Shape {
    let boundingBoxes: [CGRect]
    
           func path(in dest: CGRect) -> Path {
               
               var path = Path()
               
               let adjusted = boundingBoxes.map { cur in
                   CGRect(x: cur.minX * dest.width,
                          y: (1 - cur.origin.y) * dest.height,
                          width: dest.width * cur.width,
                          height: dest.height * cur.height)
               }
               
               path.addRects(adjusted)
               
               return path
           }
       }

struct MyShape_Previews: PreviewProvider {
    static var previews: some View {
        MyShape(boundingBoxes: [CGRect(origin: CGPoint(x: 0.25, y: 0.75), size: CGSize(width: 0.4, height: 0.7))])
            .stroke(lineWidth: 5)
            .foregroundColor(.red)
    }
}
