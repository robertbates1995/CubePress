
import SwiftUI



struct CameraView: View {
    private var model = VideoCapture()
    
    var body: some View {
        FrameView(model: model.model)
            .ignoresSafeArea()
            .overlay (alignment: .bottom){
                Button("Take Picture") {
                    
                }
                .padding()
                .background(.gray)
                .foregroundColor(.black)
                .font(.title2)
                .clipShape(RoundedRectangle(cornerRadius: 10.0, style: .continuous))
                .padding()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
