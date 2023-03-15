import AVFoundation
import CoreImage
import Vision
import UIKit

struct ColoredRect {
    var rect: VNRectangleObservation
    let color: UIColor
}

class FrameModel: NSObject, ObservableObject {
    @Published var picture: CGImage?
    @Published var coloredRects: [ColoredRect] = []
    @Published var cubeFace: CubeFaceModel?
    
    func process(cgImage: CGImage) {
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let rectangleDetectionRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRectangleObservation] else {
                return
            }
            let finder = ColorFinder()
            // Process the observations
            self.coloredRects = observations.filter({ obeservation in
                obeservation.boundingBox.width < 0.5
            }) .map {
                .init(rect: $0, color: finder.calcColor(image: cgImage, detected: $0.boundingBox) ?? .black)
            }
            self.picture = cgImage
            
            // All UI updates should be/ must be performed on the main queue.
            
        })
        //detection paramiters set here
        rectangleDetectionRequest.maximumObservations = 10
        rectangleDetectionRequest.minimumSize = 0.25
        rectangleDetectionRequest.minimumConfidence = 0.25
        
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
        self.process(cgImage: (UIImage(named: pictureString)?.cgImage)!)
    }
}
