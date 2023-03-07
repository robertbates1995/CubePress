import AVFoundation
import CoreImage
import Vision
import UIKit

class FrameModel: NSObject, ObservableObject {
    @Published var picture: CGImage?
    @Published var rects: [VNRectangleObservation] = []
    @Published var colors: [UIColor] = []
    
    func process(cgImage: CGImage) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let rectangleDetectionRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRectangleObservation] else {
                return
            }
            
            // Process the observations
            DispatchQueue.main.async { [unowned self] in
                self.rects = observations
                self.picture = cgImage
            }
            
            // All UI updates should be/ must be performed on the main queue.
            
        })
        //detection paramiters set here
        rectangleDetectionRequest.maximumObservations = 10
        rectangleDetectionRequest.minimumSize = 0.05
        rectangleDetectionRequest.minimumConfidence = 0.5
        
        do {
            try imageRequestHandler.perform([rectangleDetectionRequest])
        } catch let error {
            print("Error: \(error)")
        }
    }
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.picture = UIImage(named: pictureString)?.cgImage
    }
}
