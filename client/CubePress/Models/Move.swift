//
//  Move.swift
//  CubePress
//
//  Created by Robert Bates on 8/20/23.
//

import Foundation

enum Move: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, center, right
    var string: String {
        switch self{
        case .top:
            return "T"
        case .mid:
            return "M"
        case .bot:
            return "B"
        case .left:
            return "L"
        case .center:
            return "C"
        case .right:
            return "R"
        }
    }
}
