//
//  CubePressTests.swift
//  CubePressTests
//
//  Created by Robert Bates on 12/21/22.
//

import XCTest
@testable import CubePress

enum CubeColor: CaseIterable, Equatable {
    case red, blue, green, yellow, white, orange
    var uiColor: UIColor {
        switch self {
        case .red:
            return .red
        case .blue:
            return .blue
        case .green:
            return .green
        case .yellow:
            return .yellow
        case .white:
            return .white
        case .orange:
            return .orange
        }
    }
}

@MainActor
final class CubePressTests: XCTestCase {
    let sut = SettingsModel()
    let incoming = "{\"center\": 1550000, \"right\": 47, \"bot\": 1600000, \"left\": 3000000, \"top\": 750000, \"mid\": 1230000}"
    let expected = [Moves.center: "1550000", .right: "47", .bot: "1600000", .left: "3000000", .top: "750000", .mid: "1230000"]
    
    func testBinding() throws {
        let binding = sut.binding(for: .top)
        XCTAssertEqual(sut.settings, [:])
        XCTAssertEqual(binding.wrappedValue, "")
        binding.wrappedValue = "42"
        XCTAssertEqual(sut.settings, [.top: "42"])
        XCTAssertEqual(binding.wrappedValue, "42")
        let centerBinding = sut.binding(for: .center)
        centerBinding.wrappedValue = "47"
        XCTAssertEqual(sut.settings, [.center: "47", .top: "42"])
        XCTAssertEqual(centerBinding.wrappedValue, "47")
    }
    
    func testConversion() throws {
        let data = try XCTUnwrap(incoming.data(using:.utf8))
        sut.processData(data)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.settings, expected)
    }
    
    struct ColorFinder {
        func calcColor(image: CGImage, detected macOS: CGRect) -> UIColor {
            
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
            
            // Convert our bitmap images of r, g, b, a to a UIColor
            let sut = UIColor(red: CGFloat(bitmap[0]) / 255,
                              green: CGFloat(bitmap[1]) / 255,
                              blue: CGFloat(bitmap[2]) / 255,
                              alpha: CGFloat(bitmap[3]) / 255)
            
            // Test values
            var red: CGFloat = 0.53
            var blue: CGFloat = 0.11
            var green: CGFloat = 0.37
            
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            
            let minRGB: CGFloat = min(red, min(green,blue))
            let maxRGB: CGFloat = max(red, max(green,blue))
            
            
            if (minRGB==maxRGB) {
                hue = 0
                saturation = 0
                brightness = minRGB
            } else {
                let d: CGFloat = (red==minRGB) ? green-blue : ((blue==minRGB) ? red-green : blue-red)
                let h: CGFloat = (red==minRGB) ? 3 : ((blue==minRGB) ? 1 : 5)
                hue = (h - d/(maxRGB - minRGB)) / 6.0
                saturation = (maxRGB - minRGB)/maxRGB
                brightness = maxRGB
            }
            
            //switch statement that rounds to the nearest valid color
            if saturation > 25 {
                return .white
            } else if (248 < hue || hue <= 20) {
                return .red
            } else if (20 < hue && hue <= 50) {
                return .orange
            } else if (50 < hue && hue <= 90) {
                return .yellow
            } else if (90 < hue && hue <= 180) {
                return .green
            } else if (180 < hue && hue <= 248) {
                return .blue
            }
            return .black
        }
    }
    
    func testCalcColor() throws {
        let image = UIImage(named: "redSample", in: Bundle(for: CubePressTests.self), with: nil)!.cgImage!
        let detected = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        let sut = ColorFinder()
        XCTAssertEqual(sut.calcColor(image: image, detected: detected), .red)
    }
}
