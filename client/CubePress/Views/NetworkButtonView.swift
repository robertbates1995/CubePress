//
//  NetworkButton.swift
//  CubePress
//
//  Created by Robert Bates on 2/1/23.
//

import SwiftUI
import Foundation

struct NetworkButtonView: View {
    var move: Moves
    
    var body: some View {
        Button(move.rawValue) {
            Task {
                await sendMove()
            }
        }
    }
    func sendMove() async {
        guard let url = URL(string: "http://10.0.0.34/\(move)") else { return }
        let _ = try? await URLSession.shared.data(from: url)
    }
}

enum Moves: String, CaseIterable, Identifiable {
    var id: String {rawValue}
    
    case top, mid, bot, left, center, right
}

struct NetworkButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            ForEach(Moves.allCases) { move in
                NetworkButtonView(move: move)
                    .padding()
            }
        }
    }
}
