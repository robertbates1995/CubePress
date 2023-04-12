//
//  ControllerView.swift
//  CubePress
//
//  Created by Robert Bates on 4/12/23.
//

import SwiftUI

struct ControllerView: View {
    @ObservedObject var model: SettingsModel
    
    var body: some View {
        List {
            ForEach(MacroMove.allCases) { move in
                HStack{
                    Button("Move \(move.rawValue)") {
                        model.macroMove(to: move)
                    }
                }
            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView(model: .init())
    }
}
