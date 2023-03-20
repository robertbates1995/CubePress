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
    
    func process(ciImage: CIImage) {
        let ratio = Double(ciImage.extent.width)/Double(ciImage.extent.height)
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
            .init(rect: $0, color: finder.calcColor(image: ciImage, detected: $0) ?? .black)
        }
        let context = CIContext()
        self.picture = context.createCGImage(ciImage, from: ciImage.extent)
    }
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.process(ciImage: (UIImage(named: pictureString)?.ciImage)!)
    }
}
