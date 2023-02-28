//
//  MyShape.swift
//  CubePress
//
//  Created by Robert Bates on 2/24/23.
//

import Foundation
import SwiftUI

struct VNRectangle: Shape {
    let boundingBoxes: [CGRect]
    
           func path(in dest: CGRect) -> Path {
               
               var path = Path()
               
               let adjusted = boundingBoxes.map { macOS in
                   CGRect(x: macOS.minX * dest.width,
                          y: (1 - macOS.origin.y) * dest.height,
                          width: macOS.width * dest.width,
                          height: -macOS.height * dest.height)
                   .standardized
               }
               
               path.addRects(adjusted)
               
               return path
           }
       }

struct VNRectangle_Previews: PreviewProvider {
    static var previews: some View {
        VNRectangle(boundingBoxes: [CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 0.5, height: 0.5))])
            .stroke(lineWidth: 5)
            .foregroundColor(.red)
    }
}
