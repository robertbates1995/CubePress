
import SwiftUI

struct CameraView: View {
    let model: VideoCapture
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
    static var previews: some View {
        CameraView(model: VideoCapture(), onSolveTapped: {})
    }
}
