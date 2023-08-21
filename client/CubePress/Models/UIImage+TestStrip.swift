//
//  UIImage+TestStrip.swift
//  CubePress
//
//  Created by Robert Bates on 8/20/23.
//

import UIKit
import Foundation

extension UIImage {
    func createTestStrip(with centers: [UIImage]) -> UIImage {
        let size = CGRect(x: 0, y: 0, width: 128/3, height: 128/4)
        
        UIGraphicsBeginImageContext(CGSize(width: 128, height: 128))
        UIColor.white.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 128, height: 128))
        
        //add u face
        let uSquare = size.offsetBy(dx: size.width, dy: 0)
        draw(in: uSquare)
        centers[0].draw(in: uSquare, blendMode: .difference, alpha: 1.0)
        
        //add l face
        let lSquare = size.offsetBy(dx: 0, dy: size.height)
        draw(in: lSquare)
        centers[1].draw(in: lSquare, blendMode: .difference, alpha: 1.0)
        
        //add f face
        let fSquare = size.offsetBy(dx: size.width, dy: size.height)
        draw(in: fSquare)
        centers[2].draw(in: fSquare, blendMode: .difference, alpha: 1.0)
        
        //add r face
        let rSquare = size.offsetBy(dx: size.width * 2, dy: size.height)
        draw(in: rSquare)
        centers[3].draw(in: rSquare, blendMode: .difference, alpha: 1.0)
        
        //add b face
        let bSquare = size.offsetBy(dx: size.width, dy: size.height * 3)
        draw(in: bSquare)
        centers[4].draw(in: bSquare, blendMode: .difference, alpha: 1.0)
        
        //add d face
        let dSquare = size.offsetBy(dx: size.width, dy: size.height * 2)
        draw(in: dSquare)
        centers[5].draw(in: dSquare, blendMode: .difference, alpha: 1.0)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
