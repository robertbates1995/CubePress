//
//  ControllerView.swift
//  CubePress
//
//  Created by Robert Bates on 2/3/23.
//

import SwiftUI

struct ControllerView: View {
    var body: some View {
        List {
            ForEach(Moves.allCases) { move in
                NetworkButtonView(move: move)
            }
        }
    }
}

struct ControllerView_Previews: PreviewProvider {
    static var previews: some View {
        ControllerView()
    }
}
