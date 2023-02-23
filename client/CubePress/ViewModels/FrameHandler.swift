import AVFoundation
import CoreImage
import Vision
import UIKit

class FrameHandler: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()

    
    override init() {
        super.init()
        checkPermission()
        sessionQueue.async { [unowned self] in
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: // The user has previously granted access to the camera.
                permissionGranted = true
                
            case .notDetermined: // The user has not yet been asked for camera access.
                requestPermission()
                
        // Combine the two other cases into the default case
        default:
            permissionGranted = false
        }
    }
    
    func requestPermission() {
        // Strong reference not a problem here but might become one in the future.
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.permissionGranted = granted
        }
    }
    
    func setupCaptureSession() {
        let videoOutput = AVCaptureVideoDataOutput()
        
        guard permissionGranted else { return }
        guard let videoDevice = AVCaptureDevice.default(.builtInDualWideCamera,for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
    }
}


extension FrameHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let rectangleDetectionRequest = VNDetectRectanglesRequest(completionHandler: { (request, error) in
            guard let observations = request.results as? [VNRectangleObservation] else {
                return
            }
            
            // Process the observations
            do {
                try imageRequestHandler.perform([rectangleDetectionRequest])
            } catch let error {
                print("Error: \(error)")
            }
            
            // All UI updates should be/ must be performed on the main queue.
            DispatchQueue.main.async { [unowned self] in
                self.frame = cgImage
                
                // Create a layer for the image view
                let imageLayer = CALayer()
                let uiImage = UIImage(cgImage: cgImage)
                imageLayer.frame = CGRect(x: 0, y: 0, width: uiImage.size.width, height: uiImage.size.height)
                // Loop through the rectangle observations
                for observation in observations {
                    // Create a shape layer for the rectangle
                    let shapeLayer = CAShapeLayer()
                    shapeLayer.strokeColor = UIColor.red.cgColor
                    shapeLayer.fillColor = UIColor.clear.cgColor
                    shapeLayer.lineWidth = 2
                    
                    // Create a path for the rectangle
                    let path = UIBezierPath(rect: observation.boundingBox)
                    shapeLayer.path = path.cgPath
                    
                    // Add the shape layer to the image layer
                    imageLayer.addSublayer(shapeLayer)
                }
                
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200)) // create a new UIImageView
                imageView.image = uiImage
                // Add the image layer to the image view
                imageView.layer.addSublayer(imageLayer)
            }
        })
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    
}
