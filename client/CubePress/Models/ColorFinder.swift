//
//  calcColor.swift
//  CubePress
//
//  Created by Robert Bates on 3/2/23.
//

import Foundation
import UIKit

struct ColorFinder {
    func calcColor(image: CGImage, detected macOS: CGRect) -> UIColor? {
        
        let image = CIImage(cgImage: image)
        
        let iosRect = CGRect(x: macOS.minX *  image.extent.width,
                             y: (1 - macOS.origin.y) *  image.extent.height,
                             width: macOS.width *  image.extent.width,
                             height: -macOS.height *  image.extent.height)
            .standardized
        
        let detected = CIVector(x: iosRect.minX,
                                y: iosRect.minY,
                                z: iosRect.width,
                                w: iosRect.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: image, kCIInputExtentKey: detected]) else { return .black }
        guard let outputImage = filter.outputImage else { return .black }
        
        // A bitmap consisting of (r, g, b, a) value
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        
        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
        context.render(outputImage,
                       toBitmap: &bitmap,
                       rowBytes: 4,
                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
                       format: .RGBA8,
                       colorSpace: nil)
        
        // Test values
        let red: CGFloat = CGFloat(bitmap[0]) / 255
        let blue: CGFloat = CGFloat(bitmap[2]) / 255
        let green: CGFloat = CGFloat(bitmap[1]) / 255
        
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        
        
        let minRGB: CGFloat = min(red, min(green,blue))
        let maxRGB: CGFloat = max(red, max(green,blue))
        
        
        if (minRGB==maxRGB) {
            hue = 0
            saturation = 0
            
        } else {
            let d: CGFloat = (red==minRGB) ? green-blue : ((blue==minRGB) ? red-green : blue-red)
            let h: CGFloat = (red==minRGB) ? 3 : ((blue==minRGB) ? 1 : 5)
            hue = (h - d/(maxRGB - minRGB)) / 6.0
            saturation = (maxRGB - minRGB)/maxRGB
            
        }
        
        hue = hue * 255
        
        //switch statement that rounds to the nearest valid color
        if saturation < 0.35 {
            return .white
        } else if (248 < hue || hue <= 14) {
            return .red
        } else if (hue <= 35) {
            return .orange
        } else if (hue <= 90) {
            return .yellow
        } else if (hue <= 150) {
            return .green
        } else {
            return .blue
        }
    }
}
