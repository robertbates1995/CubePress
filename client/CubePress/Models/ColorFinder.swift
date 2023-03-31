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
        guard let classifier = try? ColorClasifier5(configuration: configuration),
              let imageClassifierVisionModel = try? VNCoreMLModel(for: classifier.model) else {return nil}
        return imageClassifierVisionModel
    }()
    
    //    /// Generates a new request instance that uses the Image Predictor's image classifier model.
    //    private func createImageClassificationRequest() -> VNImageBasedRequest {
    //        // Create an image classification request with an image classifier model.
    //
    //        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier,
    //                                                         completionHandler: visionRequestHandler)
    //
    //        imageClassificationRequest.imageCropAndScaleOption = .centerCrop
    //        return imageClassificationRequest
    //    }
    
    func calcColor(image: CIImage) -> UIColor? {
        
        //move this func!
        func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
            let context = CIContext(options: nil)
            if let cgImage = context.createCGImage(inputImage, from: inputImage.extent) {
                return cgImage
            }
            return nil
        }
        
        guard let photoImage = convertCIImageToCGImage(inputImage: image) else {
            fatalError("Photo doesn't have underlying CGImage.")
        }
        return calcColor(image: photoImage)
    }
    
    func calcColor(image: CGImage) -> UIColor? {
        
        var result: [VNClassificationObservation]?
        
        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier!,
                                                         completionHandler: { observation,_ in
            result = observation.results as? [VNClassificationObservation] })
        
        imageClassificationRequest.imageCropAndScaleOption = .scaleFill
        
        let handler = VNImageRequestHandler(cgImage: image, orientation: .up)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        try? handler.perform(requests)
                
        let foo = result?.max(by: {$0.confidence < $1.confidence})
        
        switch foo?.identifier {
        case "White":
            return .white
        case "Orange":
            return .orange
        case "Blue":
            return .blue
        case "Yellow":
            return .yellow
        case "Green":
            return .green
        case "Red":
            return .red
        default:
            return .black
        }
    }
}
