import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .overlay {
                    MyShape(boundingBoxes: [
                        CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50))
                    ])
                }
        } else {
            Color.blue
                .overlay {
                    MyShape(boundingBoxes: [CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 50, height: 50))
                                   ])
                    .stroke(lineWidth: 5)
                    .foregroundColor(.red)
                }
        }
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView()
    }
}
