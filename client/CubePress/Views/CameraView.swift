//
//  CameraView.swift
//  CubePress
//
//  Created by Robert Bates on 2/22/23.
//

import SwiftUI
import AVFoundation

class CameraView: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    
    private func setCameraInput() {
        guard let device = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera, .builtInTrueDepthCamera], mediaType: .video, position: .back).devices.first else {
            fatalError("No back camera device found.")
        }
        
        let cameraInput = try! AVCaptureDeviceInput(device: device)
        self.captureSession.addInput(cameraInput)
    }
    
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
    
    private func showCameraFeed() {
      self.previewLayer.videoGravity = .resizeAspectFill
      self.view.layer.addSublayer(self.previewLayer)
      self.previewLayer.frame = self.view.frame
    }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      self.setCameraInput()
      self.showCameraFeed()
      self.captureSession.startRunning()
    }
    override func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      self.previewLayer.frame = self.view.bounds
    }
}
