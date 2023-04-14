import AVFoundation
import CoreImage
import Vision
import UIKit

struct ColoredRect {
    var rect: CGRect
    let color: UIColor
}

class FrameModel: NSObject, ObservableObject, CubeFaceGetter {
    @MainActor @Published var picture: CGImage?
    @MainActor @Published var cubeFace = Facelet()
    @MainActor @Published var coloredRects: [ColoredRect] = []
    @MainActor private var ciImage: CIImage?
    
    func beginBackgroundProcessing() {
        //task that wraps other tasks
        Task {
            //background while loop
            while !Task.isCancelled {
                await processInBackground()
            }
        }
    }
    
    func process(ciImage: CIImage) {
        Task { @MainActor in
            let context = CIContext()
            self.picture = context.createCGImage(ciImage, from: ciImage.extent)
            self.ciImage = ciImage
        }
    }
    
    func processInBackground() async {
        let image = await Task{ @MainActor in
            self.ciImage
        }.value
        guard let image else { return }
        
        let ratio = Double(image.extent.width)/Double(image.extent.height)
        let width = 0.25
        let height = width * ratio
        var boundingBoxes = [CGRect(x: 0.125, y: 0.25 + height * 0.5, width: width, height: height * 0.5),
                             CGRect(x: 0.375, y: 0.25 + height * 0.5, width: width, height: height * 0.5),
                             CGRect(x: 0.625, y: 0.25 + height * 0.5, width: width, height: height * 0.5),
                             CGRect(x: 0.125, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + height, width: width, height: height),
                             CGRect(x: 0.125, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.375, y: 0.25 + 2 * height, width: width, height: height),
                             CGRect(x: 0.625, y: 0.25 + 2 * height, width: width, height: height),]
        boundingBoxes = boundingBoxes.map({$0.insetBy(dx: 0.015, dy: 0.015)})
        let finder = ColorFinder()
        let coloredRects: [ColoredRect] = boundingBoxes.map {
            .init(rect: $0, color: finder.calcColor(image: image.cropped(to: VNImageRectForNormalizedRect($0, Int(image.extent.width), Int(image.extent.height)))) ?? .black)
        }
        
        Task{ @MainActor in
            self.coloredRects = coloredRects
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
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.process(ciImage: (CIImage(image: UIImage(named: pictureString)!)!))
    }
}
