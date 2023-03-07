import SwiftUI

struct FrameView: View {
    var image: CGImage?
    private let label = Text("frame")
    var boundingBoxes: [CGRect]
    let finder = ColorFinder()
    
    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay {
                    ForEach(boundingBoxes, id: \.self.id) { box in
                        VNRectangle(boundingBoxes: [box])
                            .stroke(lineWidth: 3)
                            .foregroundColor(Color(finder.calcColor(image: image, detected: box) ?? .black))
                    }
                }
        } else {
            Color.blue
        }
    }
}

extension CGRect: Identifiable {
    public var id: String {
        "\(minY)\(minX)\(maxY)\(maxX)"
    }
}

struct FrameView_Previews: PreviewProvider {
    let image = UIImage(named: "rubik")?.cgImage
    
    static var previews: some View {
        FrameView(image: UIImage(named: "rubik")?.cgImage!, boundingBoxes: [CGRect(origin: CGPoint(x: 0.25, y: 0), size: CGSize(width: 50, height: 75))])
    }
}
