//
//  CubeMapModel.swift
//  CubePress
//
//  Created by Robert Bates on 3/15/23
//

import Foundation
import UIKit
import SwiftUI

//needs to look at a published property, cubeFace, in frame model.  will hand this model the property that it needs
//needs to be made observable

@MainActor
class CubeMapModel: ObservableObject {
    
    var faces = [ "U" : Face(),
                  "L" : Face(),
                  "F" : Face(),
                  "R" : Face(),
                  "B" : Face(),
                  "D" : Face(), ]
    
    @Published var U =  Face()
    @Published var L =  Face()
    @Published var F =  Face()
    @Published var R =  Face()
    @Published var B =  Face()
    @Published var D =  Face()
    
    //add function needs to add based on orientation of cube, not color of center square
    func add(face: Face) {
        //add face based on center color
        switch face.midCenter {
        case .orange:
            F = face
        case .white:
            U = face
        case .green:
            R = face
        case .blue:
            L = face
        case .red:
            B = face
        case .yellow:
            D = face
        default:
            break
        }
    }
    
    fileprivate func savePicture(_ picture: UIImage, named: String) {
        let documents = URL.documentsDirectory.appendingPathComponent(named)
        try? FileManager.default.createDirectory(at: documents, withIntermediateDirectories: true)
        let url = documents.appendingPathComponent("\(named).png")
        if let data = picture.pngData() as? NSData {
            data.write(to: url, atomically: true)
        }
    }
    
    fileprivate func saveFacePicturesFrom(_ face: Face, _ faceString: String) {
        // Obtaining the Location of the Documents Directory
        var foo = 0
        var date = Int64(Date().timeIntervalSinceReferenceDate)
        
        for i in face.sourceImages {
            savePicture(i, named: "\(foo)_\(date)")
            foo += 1
        }
    }
    
    func saveMapPictures() {
        saveFacePicturesFrom(U, "U")
        saveFacePicturesFrom(L, "L")
        saveFacePicturesFrom(F, "F")
        saveFacePicturesFrom(R, "R")
        saveFacePicturesFrom(B, "B")
        saveFacePicturesFrom(D, "D")
    }
    
    fileprivate func createTestStrip(base: UIImage, centers: [UIImage]) -> UIImage {
        let size = CGSize(width: 600, height: 100)
        
        UIGraphicsBeginImageContext(size)
        base.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
        
        var x = 0
        
        for layer in centers {
            let s2 = CGRect(x: x, y: 0, width: 100, height: 100)
            x += 100
            base.draw(in: s2)
            layer.draw(in: s2, blendMode: .difference, alpha: 1.0)
        }
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    fileprivate func saveFaceTestStrips(_ face: Face) {
        let centers = [ U.sourceImages[4], L.sourceImages[4],
                        F.sourceImages[4], R.sourceImages[4],
                        B.sourceImages[4], D.sourceImages[4] ]
        var foo = 0
        var date = Int64(Date().timeIntervalSinceReferenceDate)
        
        for i in face.sourceImages {
            savePicture(createTestStrip(base: i, centers: centers), named: "\(foo)_\(date)")
            foo += 1
        }
    }
    
    func saveTestStrips() {
        saveFaceTestStrips(U)
        saveFaceTestStrips(L)
        saveFaceTestStrips(F)
        saveFaceTestStrips(R)
        saveFaceTestStrips(B)
        saveFaceTestStrips(D)
    }
}

struct Face {
    //a data structure that represents one face of the rubix cube
    var sourceImages: [UIImage] = []
    var topLeft = UIColor.black
    var topCenter = UIColor.black
    var topRight = UIColor.black
    var midLeft = UIColor.black
    var midCenter = UIColor.black
    var midRight = UIColor.black
    var bottomLeft = UIColor.black
    var bottomCenter = UIColor.black
    var bottomRight = UIColor.black
}

enum CubeFace: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

enum FaceSquare: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case topLeft, topCenter, topRight,
         midLeft, midCenter, midRight,
         bottomLeft, bottomCenter, bottomRight
}
