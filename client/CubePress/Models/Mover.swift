//
//  Controler.swift
//  CubePress
//
//  Created by Robert Bates on 4/26/23.
//

import Foundation

enum Move: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, leftOfCenter, center, rightOfCenter, right
}

enum MacroMoves: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

let MacroMove: [String: String] = ["U": "LTMTMBXCMLTMCTMLTMC",
                  "D": "LBXCMLTMCTMRTMC",
                  "R": "LTMBXCMRTMCTMTMTM",
                  "L": "LTMTMTMBXCMLTMCTM",
                  "F": "TMLBXCTMRTMCTMTM",
                  "B": "TMTMTMLBXCTMRTMC"]
