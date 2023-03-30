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
        guard let classifier = try? ColorClasifier(configuration: configuration),
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
        
        let imageClassificationRequest = VNCoreMLRequest(model: Self.colorClassifier!,
                                                         completionHandler: { _,_ in })

        imageClassificationRequest.imageCropAndScaleOption = .centerCrop

        let handler = VNImageRequestHandler(cgImage: photoImage, orientation: .up)
        let requests: [VNRequest] = [imageClassificationRequest]
        
        // Start the image classification request.
        try? handler.perform(requests)
        
        return .black
    }
}
