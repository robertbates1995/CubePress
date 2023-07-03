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
        guard let classifier = try? colorStripClassifier9(configuration: configuration),
        let imageClassifierVisionModel = try? VNCoreMLModel(for: classifier.model) else {return nil}
        return imageClassifierVisionModel
    }()
    
    func calcColor(image: UIImage, base: [UIImage]) -> CubeFace? {
        if base.count < 1 {
            return nil
        }
        
        var result: [VNClassificationObservation]?
        
        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier!,
                                                         completionHandler: { observation,_ in
        result = observation.results as? [VNClassificationObservation] })
        
        imageClassificationRequest.imageCropAndScaleOption = .scaleFill
        
        guard let image = CIImage(image: image.createTestStrip(with: base))
        else { return nil }
        
        let handler = VNImageRequestHandler(ciImage: image)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        try? handler.perform(requests)
                
        let foo = result?.max(by: {$0.confidence < $1.confidence})
        
        switch foo?.identifier {
        case "U":
            return .U
        case "R":
            return .R
        case "F":
            return .F
        case "D":
            return .D
        case "B":
            return .B
        case "L":
            return .L
        default:
            return nil
        }
    }
}
