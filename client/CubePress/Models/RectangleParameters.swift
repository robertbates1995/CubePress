//
//  RectangleParameters.swift
//  CubePress
//
//  Created by Robert Bates on 2/24/23.
//

import Foundation

struct RectangleParameters {
    struct Segment {
        let head: CGPoint
        let tail: CGPoint
    }
    
    static let segments = [
        Segment(head: CGPoint(x: 0.0, y: 0.5), tail: CGPoint(x: 0.0, y: 0.0)),
        Segment(head: CGPoint(x: 0.5, y: 0.5), tail: CGPoint(x: 0.0, y: 0.5)),
        Segment(head: CGPoint(x: 0.5, y: 0.0), tail: CGPoint(x: 0.5, y: 0.5)),
        Segment(head: CGPoint(x: 0.0, y: 0.0), tail: CGPoint(x: 0.5, y: 0.0))
    ]
}
