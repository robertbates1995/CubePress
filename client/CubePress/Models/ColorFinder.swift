//
//  calcColor.swift
//  CubePress
//
//  Created by Robert Bates on 3/2/23.
//

import Foundation
import UIKit
import CoreML
import Vision

class ColorFinder {
    
    static let colorClassifier: VNCoreMLModel? = {
        let configuration = MLModelConfiguration()
        guard let classifier = try? colorStripClassifier_3(configuration: configuration),
        let imageClassifierVisionModel = try? VNCoreMLModel(for: classifier.model) else {return nil}
        return imageClassifierVisionModel
    }()
    
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
    
    func calcColor(image: UIImage, base: [UIImage]) -> UIColor {
        if base.count < 1 {
            return .black
        }
        
        var result: [VNClassificationObservation]?
        
        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier!,
                                                         completionHandler: { observation,_ in
        result = observation.results as? [VNClassificationObservation] })
        
        imageClassificationRequest.imageCropAndScaleOption = .scaleFill
        
        guard let image = CIImage(image: createTestStrip(base: image, centers: base))
        else { return .black }
        
        let handler = VNImageRequestHandler(ciImage: image)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        try? handler.perform(requests)
                
        let foo = result?.max(by: {$0.confidence < $1.confidence})
        
        switch foo?.identifier {
        case "U":
            return .white
        case "R":
            return .orange
        case "F":
            return .blue
        case "D":
            return .yellow
        case "B":
            return .green
        case "L":
            return .red
        default:
            return .white
        }
    }
}
