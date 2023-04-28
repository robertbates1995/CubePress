//
//  Controler.swift
//  CubePress
//
//  Created by Robert Bates on 4/26/23.
//

import Foundation

class Mover {
    
    let conversionTable = ["U": "LTMTMBXCM",
                     "U'": "LTMTMBXCM",
                     "U2": "LTMTMBXCM",
                     "U2'": "LTMTMBXCM",
                     "D": "LBXCM",
                     "R": "LTMBXCM",
                     "L": "LTMTMTMBXCM",
                     "F": "TMLBXCM",
                     "B": "TMTMTMLBXCM"]
    
    var referenceFrame = ["U" : "U",
                            "L" : "L",
                            "F" : "F",
                            "R" : "R",
                            "B" : "B",
                            "D" : "D",]
    
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

let MacroMove: [String: String] = ["U": "LTMTMBXCM",
                                   "U'": "LTMTMBXCM",
                                   "U2": "LTMTMBXCM",
                                   "U2'": "LTMTMBXCM",
                                   "D": "LBXCM",
                                   "R": "LTMBXCM",
                                   "L": "LTMTMTMBXCM",
                                   "F": "TMLBXCM",
                                   "B": "TMTMTMLBXCM"]

let MacroMoveWithReset: [String: String] = ["U": "LTMTMBXCMLTMCTMLTMC",
                                            "U'": "LTMTMBXCMLTMCTMLTMC",
                                            "U2": "LTMTMBXCMLTMCTMLTMC",
                                            "U2'": "LTMTMBXCMLTMCTMLTMC",
                                            "D": "LBXCMLTMCTMRTMC",
                                            "R": "LTMBXCMRTMCTMTMTM",
                                            "L": "LTMTMTMBXCMLTMCTM",
                                            "F": "TMLBXCTMRTMCTMTM",
                                            "B": "TMTMTMLBXCTMRTMC"]


