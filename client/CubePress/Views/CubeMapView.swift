//
//  CubeMapView.swift
//  CubePress
//
//  Created by Robert Bates on 3/9/23.
//

import SwiftUI

//abstract into cubemapmodel file

struct CubeMapView: View {
    @ObservedObject var model: CubeMapModel
    @State private var selection: Int = 1
    
    var body: some View {
        FullMapView
        Picker("Select Room Type", selection: self.$selection) {
                           Image("View").tag(1)
                           Image("Edit").tag(2)
        }
                       .frame(width: 300)
                       .pickerStyle(.segmented)
    }
    
    var FullMapView: some View {

        VStack{
            Grid(horizontalSpacing: 30){
                GridRow{
                    Color.mint
                    //Up
                    CubeFaceView(model: model.U, faceLabel: "Up")
                    Color.mint
                }
                GridRow{
                    CubeFaceView(model: model.L, faceLabel: "Left")
                    CubeFaceView(model: model.F, faceLabel: "Front")
                    CubeFaceView(model: model.R, faceLabel: "Right")
                    //front 3 sides
                }
                GridRow{
                    Color.mint
                    //bottom
                    CubeFaceView(model: model.D, faceLabel: "Down")
                    Color.mint
                }
                GridRow{
                    Color.mint
                    //back
                    CubeFaceView(model: model.B, faceLabel: "Back")
                    Color.mint
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mint)
            .padding()
            Button("Save test strips") {
                model.saveTestStrips()
            }
            Button("Update Colors") {
                model.updateColors()
            }
            .padding()
        }
    }
    
    struct CubeFaceView: View {
        var model: Face
        var faceLabel: String
        
        var body: some View {
            VStack{
                Grid {
                    GridRow{
                        sourceImage(index: 6)
                            .border(Color(uiColor: model.topLeft), width: 3)
                        sourceImage(index: 7)
                            .border(Color(uiColor: model.topCenter), width: 3)
                        sourceImage(index: 8)
                            .border(Color(uiColor: model.topRight), width: 3)
                    }
                    GridRow{
                        sourceImage(index: 3)
                            .border(Color(uiColor: model.midLeft), width: 3)
                        sourceImage(index: 4)
                            .border(Color(uiColor: model.midCenter), width: 3)
                        sourceImage(index: 5)
                            .border(Color(uiColor: model.midRight), width: 3)
                    }
                    GridRow{
                        sourceImage(index: 0)
                            .border(Color(uiColor: model.bottomLeft), width: 3)
                        sourceImage(index: 1)
                            .border(Color(uiColor: model.bottomCenter), width: 3)
                        sourceImage(index: 2)
                            .border(Color(uiColor: model.bottomRight), width: 3)
                    }
                }
                .aspectRatio(contentMode: .fit)
                Text(faceLabel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.mint)
        }
        
        @ViewBuilder
        func sourceImage(index: Int) -> some View {
            if model.sourceImages.count < 9 {
                Color.black
            }
            else {
                Image(uiImage: model.sourceImages[index])
                    .resizable()
                    .frame(idealWidth: .greatestFiniteMagnitude, idealHeight: .greatestFiniteMagnitude)
                    .aspectRatio(1.0, contentMode: .fit)
            }
        }
    }
}

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )
        
        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
}

struct CubeMapView_Previews: PreviewProvider {
    struct Wrapper: View {
        @ObservedObject var frame: FrameModel
        
        var body: some View {
            CubeMapView.CubeFaceView(model: frame.cubeFace, faceLabel: "test")
        }
    }
    
    static var model: CubeMapModel {
        let temp = CubeMapModel()
        temp.F.sourceImages = Array(repeating: UIImage(named: "blueSample")!, count: 9)
              temp.L.sourceImages = Array(repeating: UIImage(named: "redSample")!, count: 9)
              temp.R.sourceImages = Array(repeating: UIImage(named: "orangeSample")!, count: 9)
              temp.U.sourceImages = Array(repeating: UIImage(named: "whiteSample")!, count: 9)
              temp.B.sourceImages = Array(repeating: UIImage(named: "greenSample")!, count: 9)
              temp.D.sourceImages = Array(repeating: UIImage(named: "yellowSample")!, count: 9)
        temp.updateColors()
        return temp
    }
    
    static var previews: some View {
        CubeMapView(model: model)
        Wrapper(frame: FrameModel(pictureString: "rubik"))
    }
}
