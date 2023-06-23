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
    
    @Published var U =  Face(face: .U)
    @Published var L =  Face(face: .L)
    @Published var F =  Face(face: .F)
    @Published var R =  Face(face: .R)
    @Published var B =  Face(face: .B)
    @Published var D =  Face(face: .D)
    
    var centers: [UIImage] {[U.centerImage, L.centerImage,
                                     F.centerImage, R.centerImage,
                                     B.centerImage, D.centerImage].compactMap({$0})}
    
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
    
    fileprivate func saveFaceTestStrips(_ face: Face, _ named: String) {
        var foo = 0
        let date = Int64(Date().timeIntervalSince1970 * 10000)
        let strips: [UIImage] = face.sourceImages.map({$0.createTestStrip(with: centers)})
        
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
        //call save on all faces then change face orientation
        saveThenRotate()
        saveThenRotate()
        saveThenRotate()
        saveThenRotate()
    }
    
    //updateColors function for future use
    func updateColors() {
        U.updateColors(with: centers)
        L.updateColors(with: centers)
        F.updateColors(with: centers)
        R.updateColors(with: centers)
        B.updateColors(with: centers)
        D.updateColors(with: centers)
    }
    
    func move(to: String) {
        switch to.first {
        case "D":
            move(to, transform: transformD)
        case "U":
            move(to, transform: transformU)
        case "L":
            move(to, transform: transformL)
        case "R":
            move(to, transform: transformR)
        case "B":
            move(to, transform: transformB)
        case "F":
            move(to, transform: transformF)
        default:
            break
        }
    }
}

enum FaceSquare: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case topLeft, topCenter, topRight,
         midLeft, midCenter, midRight,
         bottomLeft, bottomCenter, bottomRight
}

extension CubeMapModel {
    
    fileprivate func saveThenRotate() {
        saveAllTestStrips()
        rotateFaces()
    }
    
    fileprivate func saveAllTestStrips() {
        saveFaceTestStrips(U, "U")
        saveFaceTestStrips(L, "L")
        saveFaceTestStrips(F, "F")
        saveFaceTestStrips(R, "R")
        saveFaceTestStrips(B, "B")
        saveFaceTestStrips(D, "D")
    }
    
    fileprivate func rotateFaces(){
        let temp = L
        L = D
        D = R
        R = U
        U = temp
    }
    
    fileprivate func move(_ move: String, transform: () -> Void) {
        switch move.dropFirst(1) {
        case "'":
            transform()
            transform()
            transform()
        case "2", "2'":
            transform()
            transform()
        default:
            transform()
        }
    }
    
    fileprivate func transformD() {
        //change sides being turned
        let tempEdge = F.bottomEdge
        F.bottomEdge = L.bottomEdge
        L.bottomEdge = B.bottomEdge
        B.bottomEdge = R.bottomEdge
        R.bottomEdge = tempEdge
        //change rotated face
        D.rotateClockwise()
    }
    
    fileprivate func transformU() {
        //change sides being turned
        let tempEdge = F.topEdge
        F.topEdge = R.topEdge
        R.topEdge = B.topEdge
        B.topEdge = L.topEdge
        L.topEdge = tempEdge
        //change rotated face
        U.rotateClockwise()
    }
    
    fileprivate func transformR() {
        //change sides being turned
        let tempEdge = U.rightEdge
        U.rightEdge = F.rightEdge
        F.rightEdge = D.rightEdge
        D.rightEdge = B.leftEdge
        B.leftEdge = tempEdge
        //change rotated face
        R.rotateClockwise()
    }
    
    fileprivate func transformL() {
        //change sides being turned
        let tempEdge = F.leftEdge
        F.leftEdge = U.leftEdge
        U.leftEdge = B.rightEdge
        B.rightEdge = D.leftEdge
        D.leftEdge = tempEdge
        //change rotated face
        L.rotateClockwise()
    }
    
    fileprivate func transformB() {
        //change sides being turned
        let tempEdge = R.rightEdge
        R.rightEdge = D.bottomEdge
        D.bottomEdge = L.leftEdge
        L.leftEdge = U.topEdge
        U.topEdge = tempEdge
        //change rotated face
        B.rotateClockwise()
    }
    
    fileprivate func transformF() {
        //change sides being turned
        let tempEdge = U.bottomEdge
        U.bottomEdge = L.rightEdge
        L.rightEdge = D.topEdge
        D.topEdge = R.leftEdge
        R.leftEdge = tempEdge
        //change rotated face
        F.rotateClockwise()
    }
}

extension UIImage {
    func createTestStrip(with centers: [UIImage]) -> UIImage {
        let size = CGRect(x: 0, y: 0, width: 128/3, height: 128/4)
        
        UIGraphicsBeginImageContext(CGSize(width: 128, height: 128))
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 128, height: 128))
        
        //add u face
        let uSquare = size.offsetBy(dx: size.width, dy: 0)
        draw(in: uSquare)
        centers[0].draw(in: uSquare, blendMode: .difference, alpha: 1.0)
        
        //add l face
        let lSquare = size.offsetBy(dx: 0, dy: size.height)
        draw(in: lSquare)
        centers[1].draw(in: lSquare, blendMode: .difference, alpha: 1.0)
        
        //add f face
        let fSquare = size.offsetBy(dx: size.width, dy: size.height)
        draw(in: fSquare)
        centers[2].draw(in: fSquare, blendMode: .difference, alpha: 1.0)
        
        //add r face
        let rSquare = size.offsetBy(dx: size.width * 2, dy: size.height)
        draw(in: rSquare)
        centers[3].draw(in: rSquare, blendMode: .difference, alpha: 1.0)
        
        //add b face
        let bSquare = size.offsetBy(dx: size.width, dy: size.height * 3)
        draw(in: bSquare)
        centers[4].draw(in: bSquare, blendMode: .difference, alpha: 1.0)
        
        //add d face
        let dSquare = size.offsetBy(dx: size.width, dy: size.height * 2)
        draw(in: dSquare)
        centers[5].draw(in: dSquare, blendMode: .difference, alpha: 1.0)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
