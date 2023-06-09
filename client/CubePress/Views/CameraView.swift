
import SwiftUI

protocol VideoCapturing {
    var model: FrameModel { get }
}

extension VideoCapture: VideoCapturing {
    
}

struct CameraView: View {
    let model: VideoCapturing
    let onSolveTapped: () -> ()
    
    var body: some View {
        FrameView(model: model.model)
            .overlay (alignment: .bottom){
                Button("Solve") {
                    onSolveTapped()
                }
                .padding()
                .background(.gray)
                .foregroundColor(.black)
                .font(.title2)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .padding()
            }
            .onAppear() {
                //model.startCamera
            }
            .onDisappear() {
                //model.stopCamera
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    class Mock: VideoCapturing {
        let model = FrameModel(pictureString: "rubik")
    }
    static var previews: some View {
        CameraView(model: Mock(), onSolveTapped: {})
    }
}
