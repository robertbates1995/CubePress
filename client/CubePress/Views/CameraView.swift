
import SwiftUI



struct CameraView: View {
    @StateObject private var model = FrameModel()
    
    var body: some View {
        FrameView(image: model.picture, boundingBoxes: model.rects.map(\.boundingBox))
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
