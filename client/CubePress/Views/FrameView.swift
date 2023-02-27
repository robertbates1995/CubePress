import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    var boundingBoxes: [CGRect]
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .overlay {
                    VNRectangle(boundingBoxes: boundingBoxes)
                        .stroke(lineWidth: 1)
                }
        } else {
            Color.blue
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(boundingBoxes: [CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50))])
    }
}
