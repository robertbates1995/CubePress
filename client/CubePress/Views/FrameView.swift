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
                    ForEach(model.coloredRects, id: \.self.id) { foo in
                        VNRectangle(boundingBoxes: [foo.rect])
                            .stroke(lineWidth: 3)
                            .foregroundColor(Color(foo.color))
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

extension ColoredRect: Identifiable {
    public var id: String {
        "\(rect)\(color)"
    }
}

struct FrameView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(model: FrameModel(pictureString: "rubik"))
    }
}
