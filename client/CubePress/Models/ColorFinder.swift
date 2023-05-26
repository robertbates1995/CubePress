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
        guard let classifier = try? colorStripClassifier1(configuration: configuration),
              let imageClassifierVisionModel = try? VNCoreMLModel(for: classifier.model) else {return nil}
        return imageClassifierVisionModel
    }()
    
    func calcColor(image: UIImage, base: [UIImage]) -> UIColor {
        if base.count < 1 {
            return .black
        }
        
        var result: [VNClassificationObservation]?
        
        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier!,
                                                         completionHandler: { observation,_ in
            result = observation.results as? [VNClassificationObservation] })
        
        imageClassificationRequest.imageCropAndScaleOption = .scaleFill
        
        guard let image = image.ciImage
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
