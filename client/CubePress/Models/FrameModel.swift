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
        var boundingBoxes = [CGRect(x: 0.125, y: 0.25, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25, width: width, height: height),
                             CGRect(x: 0.125, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.125, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + 2 * height, width: width, height: height),]
        boundingBoxes = boundingBoxes.map({$0.insetBy(dx: 0.015, dy: 0.015)})
        let finder = ColorFinder()
        coloredRects = boundingBoxes.map {
            .init(rect: $0, color: finder.calcColor(image: ciImage, detected: $0) ?? .black)
        }
        let context = CIContext()
        self.picture = context.createCGImage(ciImage, from: ciImage.extent)
        cubeFace.topLeft = coloredRects[0].color
        cubeFace.topCenter = coloredRects[1].color
        cubeFace.topRight = coloredRects[2].color
        cubeFace.midLeft = coloredRects[3].color
        cubeFace.midCenter = coloredRects[4].color
        cubeFace.midRight = coloredRects[5].color
        cubeFace.bottomLeft = coloredRects[6].color
        cubeFace.bottomCenter = coloredRects[7].color
        cubeFace.bottomRight = coloredRects[8].color
    }
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.process(ciImage: (CIImage(image: UIImage(named: pictureString)!)!))
    }
}
