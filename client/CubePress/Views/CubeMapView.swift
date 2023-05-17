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
    
    var body: some View {
        Grid{
            GridRow{
                Color.white
                //Up
                CubeFaceView(model: model.U, faceLabel: "Up")
                Color.white
            }
            GridRow{
                CubeFaceView(model: model.L, faceLabel: "Left")
                CubeFaceView(model: model.F, faceLabel: "Front")
                CubeFaceView(model: model.R, faceLabel: "Right")
                //front 3 sides
            }
            GridRow{
                Color.white
                //bottom
                CubeFaceView(model: model.D, faceLabel: "Down")
                Color.white
            }
            GridRow{
                Color.white
                //back
                CubeFaceView(model: model.B, faceLabel: "Back")
                Color.white
            }
        }
        .aspectRatio(contentMode: .fit)
        .padding()
    }
    
    struct CubeFaceView: View {
        var model: Face
        var faceLabel: String
        
        var body: some View {
            VStack{
                Grid {
                    GridRow{
                        sourceImage(index: 6)
                        sourceImage(index: 7)
                        sourceImage(index: 8)
                    }
                    GridRow{
                        sourceImage(index: 3)
                        sourceImage(index: 4)
                        sourceImage(index: 5)
                    }
                    GridRow{
                        sourceImage(index: 0)
                        sourceImage(index: 1)
                        sourceImage(index: 2)
                    }
                }
                .aspectRatio(contentMode: .fit)
                Text(faceLabel)
            }
        }
        
        func sourceImage(index: Int) -> Image {
            let frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 30, height: 30))
            let cgImage = CIContext().createCGImage(CIImage(color: .black), from: frame)!
            if model.sourceImages.count < 9 {
                let uiImage = UIImage(cgImage: cgImage)
                return Image(uiImage: uiImage)
            }
            return Image(uiImage: model.sourceImages[index].scalePreservingAspectRatio(targetSize: CGSize(width: 30, height: 30)))
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
    static var model: CubeMapModel {
        var temp = CubeMapModel()
        temp.U.sourceImages = Array(repeating: UIImage(named: "fourColors")!, count: 9)
        return temp
    }
    static var previews: some View {
        CubeMapView(model: model)
    }
}
