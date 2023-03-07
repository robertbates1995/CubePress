import SwiftUI

struct FrameView: View {
    @ObservedObject var model: FrameModel
    private let label = Text("frame")
    let finder = ColorFinder()
    
    var body: some View {
        if let image = $model.picture.wrappedValue {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .overlay {
                    ForEach(model.rects.map(\.boundingBox), id: \.self.id) { box in
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
        FrameView(model: FrameModel(pictureString: "rubik"))
    }
}
