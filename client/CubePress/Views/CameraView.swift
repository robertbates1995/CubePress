
import SwiftUI



struct CameraView: View {
    private var model = VideoCapture()
    
    var body: some View {
        FrameView(model: model.model)
            .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
