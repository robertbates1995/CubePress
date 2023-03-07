import AVFoundation
import CoreImage
import Vision
import UIKit

class FrameModel: NSObject, ObservableObject {
    @Published var picture: CGImage?
    @Published var rects: [VNRectangleObservation] = []
    @Published var colors: [UIColor] = []
    var capture = VideoCapture()
}


extension FrameModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
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
    
    func calcColors() {
        guard let picture else {return}
        colors = rects.map({mapColor(image: picture, boundingBox: $0)})
    }
    
    func mapColor(image: CGImage, boundingBox: VNRectangleObservation) -> UIColor {
        .red
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = capture.context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    
}
