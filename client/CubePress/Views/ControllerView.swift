//
//  ControllerView.swift
//  CubePress
//
//  Created by Robert Bates on 4/12/23.
//

import SwiftUI

struct ControllerView: View {
    var model: Mover
    
    var body: some View {
        List {
            ForEach(CubeFace.allCases) { move in
                HStack{
                    Button("Move \(move.rawValue)") {
                        Task{
                            try? await model.input(moves: [move.rawValue])
                        }
                    }
                }
            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView(model: Mover(settings: SettingsModel()))
    }
}
