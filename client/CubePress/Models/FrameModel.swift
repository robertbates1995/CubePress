import AVFoundation
import CoreImage
import Vision
import UIKit

struct ColoredRect {
    var rect: CGRect
    var image: UIImage
    let color: CubeFace?
}

class FrameModel: NSObject, ObservableObject, CubeFaceGetter {
    @MainActor @Published var picture: CGImage?
    @MainActor @Published var cubeFace = Face()
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
        let coloredRects: [ColoredRect] = boundingBoxes.map {
            let rect = VNImageRectForNormalizedRect($0, Int(image.extent.width), Int(image.extent.height))
            let temp = image.cropped(to: rect)
            return ColoredRect(rect: $0, image: testImage(base: temp, rect: rect), color: nil)
        }
        
        Task{ @MainActor in
            cubeFace.sourceImages = coloredRects.map(\.image)
            self.coloredRects = coloredRects
            cubeFace.topLeft = coloredRects[6].color
            cubeFace.topCenter = coloredRects[7].color
            cubeFace.topRight = coloredRects[8].color
            cubeFace.midLeft = coloredRects[3].color
            cubeFace.midCenter = coloredRects[4].color
            cubeFace.midRight = coloredRects[5].color
            cubeFace.bottomLeft = coloredRects[0].color
            cubeFace.bottomCenter = coloredRects[1].color
            cubeFace.bottomRight = coloredRects[2].color
        }
    }
    
    func testImage(base: CIImage, rect: CGRect) -> UIImage {
        var rect = rect.integral
        rect = rect.offsetBy(dx: -rect.minX, dy: -rect.minY)
        UIGraphicsBeginImageContext(rect.size)
        UIImage(named: "fourColors")!.draw(in: rect)
        UIImage(ciImage: base).draw(in: rect)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

extension FrameModel {
    convenience init(pictureString: String) {
        self.init()
        self.process(ciImage: (CIImage(image: UIImage(named: pictureString)!)!))
        beginBackgroundProcessing()
    }
}
