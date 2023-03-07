import AVFoundation
import CoreImage
import Vision
import UIKit

class FrameModel: NSObject, ObservableObject {
    @Published var picture: CGImage?
    @Published var rects: [VNRectangleObservation] = []
    @Published var colors: [UIColor] = []
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
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
    
}