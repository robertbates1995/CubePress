//
//  Controler.swift
//  CubePress
//
//  Created by Robert Bates on 4/26/23.
//

import Foundation

class Mover {
    
    let conversionTable = ["U": "TMTM",
                           "D": "",
                           "R": "LTMC",
                           "L": "RTMC",
                           "F": "TM",
                           "B": "TMTMTM"]
    
    func input(move: String) {
        
    }
    
    func input(macroMove: String) {
        switch (macroMove) {
        case "U":
            //change referenceFrame
            //input comand to CUBOTino
            return
        case "L":
            //change referenceFrame
            //input comand to CUBOTino
            return
        case "F":
            //change referenceFrame
            //input comand to CUBOTino
            return
        case "R":
            //change referenceFrame
            //input comand to CUBOTino
            return
        case "B":
            //change referenceFrame
            //input comand to CUBOTino
            return
        case "D":
            //change referenceFrame
            //input comand to CUBOTino
            return
        default:
            return
        }
    }
}

enum Move: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case top, mid, bot, left, leftOfCenter, center, rightOfCenter, right
}

enum MacroMoves: String, CaseIterable, Identifiable, Codable {
    var id: String {rawValue}
    
    case U, D, R, L, F, B
}

let MacroMove: [String: String] = ["U": "TMTM",
                                   "D": "",
                                   "R": "LTMC",
                                   "L": "RTMC",
                                   "F": "TM",
                                   "B": "TMTMTM"]
