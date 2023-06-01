//
//  CubeMapModel.swift
//  CubePress
//
//  Created by Robert Bates on 3/15/23
//

import Foundation
import UIKit
import SwiftUI

//needs to look at a published property, cubeFace, in frame model. Will hand this model the property that it needs
//needs to be made observable

@MainActor
class CubeMapModel: ObservableObject {
    
    var faces = ["U" : Face(),
                 "L" : Face(),
                 "F" : Face(),
                 "R" : Face(),
                 "B" : Face(),
                 "D" : Face(),]
    
    private var centers: [UIImage] {[U.centerImage, L.centerImage,
                                     F.centerImage, R.centerImage,
                                     B.centerImage, D.centerImage].compactMap({$0})}
    
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
        let date = Int64(Date().timeIntervalSinceReferenceDate)
        
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
    
    func createTestStrip(base: UIImage, centers: [UIImage]) -> UIImage {
        let size = CGSize(width: 300, height: 400)
        
        UIGraphicsBeginImageContext(size)
        UIColor.white.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        //add u face
        let uSquare = CGRect(x: 100, y: 0, width: 100, height: 100)
        base.draw(in: uSquare)
        centers[0].draw(in: uSquare, blendMode: .difference, alpha: 1.0)
        
        //add l face
        let lSquare = CGRect(x: 0, y: 100, width: 100, height: 100)
        base.draw(in: lSquare)
        centers[1].draw(in: lSquare, blendMode: .difference, alpha: 1.0)
        
        //add f face
        let fSquare = CGRect(x: 100, y: 100, width: 100, height: 100)
        base.draw(in: fSquare)
        centers[2].draw(in: fSquare, blendMode: .difference, alpha: 1.0)
        
        //add r face
        let rSquare = CGRect(x: 200, y: 100, width: 100, height: 100)
        base.draw(in: rSquare)
        centers[3].draw(in: rSquare, blendMode: .difference, alpha: 1.0)
        
        //add b face
        let bSquare = CGRect(x: 100, y: 300, width: 100, height: 100)
        base.draw(in: bSquare)
        centers[4].draw(in: bSquare, blendMode: .difference, alpha: 1.0)
        
        //add d face
        let dSquare = CGRect(x: 100, y: 200, width: 100, height: 100)
        base.draw(in: dSquare)
        centers[5].draw(in: dSquare, blendMode: .difference, alpha: 1.0)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    fileprivate func saveFaceTestStrips(_ face: Face, _ named: String) {
        var foo = 0
        let date = Int64(Date().timeIntervalSince1970)
        var strips: [UIImage] = []
        
        for i in face.sourceImages {
            strips += [createTestStrip(base: i, centers: centers)]
        }
        
        let directory = URL.documentsDirectory.appendingPathComponent(named)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        for i in strips {
            let url = directory.appendingPathComponent("\(named)_\(foo)_\(date).png")
            if let data = i.pngData() as? NSData {
                data.write(to: url, atomically: true)
            }
            foo += 1
        }
    }
    
    func saveTestStrips() {
        //TODO: FIX THIS
        //call save on all faces
        saveFaceTestStrips(U, "U")
        saveFaceTestStrips(L, "L")
        saveFaceTestStrips(F, "F")
        saveFaceTestStrips(R, "R")
        saveFaceTestStrips(B, "B")
        saveFaceTestStrips(D, "D")
        //change face orientation
        var temp = L
        L = D
        D = R
        R = U
        U = temp
        //call save on all faces
        saveFaceTestStrips(U, "U")
        saveFaceTestStrips(L, "L")
        saveFaceTestStrips(F, "F")
        saveFaceTestStrips(R, "R")
        saveFaceTestStrips(B, "B")
        saveFaceTestStrips(D, "D")
        temp = L
        L = D
        D = R
        R = U
        U = temp
        saveFaceTestStrips(U, "U")
        saveFaceTestStrips(L, "L")
        saveFaceTestStrips(F, "F")
        saveFaceTestStrips(R, "R")
        saveFaceTestStrips(B, "B")
        saveFaceTestStrips(D, "D")
        temp = L
        L = D
        D = R
        R = U
        U = temp
        saveFaceTestStrips(U, "U")
        saveFaceTestStrips(L, "L")
        saveFaceTestStrips(F, "F")
        saveFaceTestStrips(R, "R")
        saveFaceTestStrips(B, "B")
        saveFaceTestStrips(D, "D")
        //Reset to normal
        temp = L
        L = D
        D = R
        R = U
        U = temp
    }
    
    func updateColors() {
        U.updateColors(with: centers)
        L.updateColors(with: centers)
        F.updateColors(with: centers)
        R.updateColors(with: centers)
        B.updateColors(with: centers)
        D.updateColors(with: centers)
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
    
    var centerImage: UIImage? {sourceImages.count > 0 ? sourceImages[4] : nil}
    
    mutating func updateColors(with centers: [UIImage]) {
        let finder = ColorFinder()
        topLeft = finder.calcColor(image: sourceImages[6], base: centers)
        topCenter = finder.calcColor(image: sourceImages[7], base: centers)
        topRight = finder.calcColor(image: sourceImages[8], base: centers)
        midLeft = finder.calcColor(image: sourceImages[3], base: centers)
        midCenter = finder.calcColor(image: sourceImages[4], base: centers)
        midRight = finder.calcColor(image: sourceImages[5], base: centers)
        bottomLeft = finder.calcColor(image: sourceImages[0], base: centers)
        bottomCenter = finder.calcColor(image: sourceImages[1], base: centers)
        bottomRight = finder.calcColor(image: sourceImages[2], base: centers)
    }
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
