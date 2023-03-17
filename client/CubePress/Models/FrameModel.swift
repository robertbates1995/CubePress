import AVFoundation
import CoreImage
import Vision
import UIKit

struct ColoredRect {
    var rect: CGRect
    let color: UIColor
}

class FrameModel: NSObject, ObservableObject, CubeFaceGetter {
    @Published var picture: CGImage?
    @Published var coloredRects: [ColoredRect] = []
    @Published var cubeFace = CubeFace()
    
    func process(cgImage: CGImage) {
        let ratio = Double(cgImage.width)/Double(cgImage.height)
        let width = 0.25
        let height = width * ratio
        let boundingBoxes = [CGRect(x: 0.125, y: 0.25, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25, width: width, height: height),
                             CGRect(x: 0.125, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.125, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + 2 * height, width: width, height: height),]
        let finder = ColorFinder()
        coloredRects = boundingBoxes.map {
            .init(rect: $0, color: finder.calcColor(image: cgImage, detected: $0) ?? .black)
        }
        self.picture = cgImage
    }
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.process(cgImage: (UIImage(named: pictureString)?.cgImage)!)
    }
}
